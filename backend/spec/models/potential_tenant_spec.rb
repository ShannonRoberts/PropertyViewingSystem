require 'rails_helper'

RSpec.describe PotentialTenant, type: :model do
  let(:valid_attributes) do
    {
      name: 'John Doe',
      email: 'john.doe@example.com',
      phone: '+61-400-123-456'
    }
  end

  describe 'associations' do
    it { should have_many(:viewings).dependent(:destroy) }
    it { should have_many(:properties).through(:viewings) }
  end

  describe 'validations' do
    describe 'presence validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:phone) }
    end

    describe 'length validations' do
      it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
    end

    describe 'uniqueness validations' do
      subject { build(:potential_tenant) }
      # Since we downcase emails in before_save, we test uniqueness without case sensitivity differently
      it 'validates email uniqueness' do
        should validate_uniqueness_of(:email)
      end
    end

    describe 'format validations' do
      it { should allow_value('user@example.com').for(:email) }
      it { should allow_value('test.email+tag@domain.co.uk').for(:email) }
      it { should_not allow_value('invalid_email').for(:email) }
      it { should_not allow_value('user@').for(:email) }
      it { should_not allow_value('@domain.com').for(:email) }
      it { should_not allow_value('user.domain.com').for(:email) }
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      it 'downcases email before saving' do
        tenant = PotentialTenant.new(valid_attributes.merge(email: 'JOHN.DOE@EXAMPLE.COM'))
        tenant.save!
        expect(tenant.email).to eq('john.doe@example.com')
      end

      it 'preserves already lowercase email' do
        tenant = PotentialTenant.new(valid_attributes)
        tenant.save!
        expect(tenant.email).to eq('john.doe@example.com')
      end

      it 'handles mixed case email' do
        tenant = PotentialTenant.new(valid_attributes.merge(email: 'John.Doe@Example.COM'))
        tenant.save!
        expect(tenant.email).to eq('john.doe@example.com')
      end
    end
  end

  describe 'edge cases' do
    it 'handles minimum valid name length' do
      tenant = PotentialTenant.new(valid_attributes.merge(name: 'Jo'))
      expect(tenant).to be_valid
    end

    it 'handles maximum valid name length' do
      long_name = 'A' * 50
      tenant = PotentialTenant.new(valid_attributes.merge(name: long_name))
      expect(tenant).to be_valid
    end

    it 'is invalid with name too short' do
      tenant = PotentialTenant.new(valid_attributes.merge(name: 'J'))
      expect(tenant).not_to be_valid
      expect(tenant.errors[:name]).to include('is too short (minimum is 2 characters)')
    end

    it 'is invalid with name too long' do
      long_name = 'A' * 51
      tenant = PotentialTenant.new(valid_attributes.merge(name: long_name))
      expect(tenant).not_to be_valid
      expect(tenant.errors[:name]).to include('is too long (maximum is 50 characters)')
    end

    it 'handles various phone number formats' do
      phone_formats = [
        '+61-400-123-456',
        '0400 123 456',
        '(03) 9123 4567',
        '+1-555-123-4567',
        '123-456-7890'
      ]

      phone_formats.each do |phone|
        tenant = PotentialTenant.new(valid_attributes.merge(phone: phone))
        expect(tenant).to be_valid, "Phone format #{phone} should be valid"
      end
    end
  end

  describe 'uniqueness scenarios' do
    let!(:existing_tenant) { create(:potential_tenant, email: 'existing@example.com') }

    it 'prevents creating tenant with duplicate email' do
      duplicate_tenant = PotentialTenant.new(valid_attributes.merge(email: 'existing@example.com'))
      expect(duplicate_tenant).not_to be_valid
      expect(duplicate_tenant.errors[:email]).to include('has already been taken')
    end

    it 'prevents creating tenant with duplicate email in different case' do
      duplicate_tenant = PotentialTenant.new(valid_attributes.merge(email: 'EXISTING@EXAMPLE.COM'))
      # This will be valid before saving because the downcase happens in before_save
      expect(duplicate_tenant.valid?).to be true
      # But saving should fail due to uniqueness constraint after downcasing
      expect { duplicate_tenant.save! }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it 'allows different tenants with same name but different email' do
      tenant = PotentialTenant.new(valid_attributes.merge(
        name: existing_tenant.name,
        email: 'different@example.com'
      ))
      expect(tenant).to be_valid
    end

    it 'allows different tenants with same phone but different email' do
      tenant = PotentialTenant.new(valid_attributes.merge(
        phone: existing_tenant.phone,
        email: 'different@example.com'
      ))
      expect(tenant).to be_valid
    end
  end

  describe 'business logic scenarios' do
    it 'can have multiple viewings' do
      tenant = create(:potential_tenant)
      property1 = create(:property)
      property2 = create(:property)

      viewing1 = create(:viewing, potential_tenant: tenant, property: property1)
      viewing2 = create(:viewing, potential_tenant: tenant, property: property2)

      expect(tenant.viewings).to include(viewing1, viewing2)
      expect(tenant.properties).to include(property1, property2)
    end

    it 'destroys associated viewings when tenant is deleted' do
      tenant = create(:potential_tenant)
      viewing = create(:viewing, potential_tenant: tenant)

      expect { tenant.destroy }.to change { Viewing.count }.by(-1)
    end
  end

  describe 'valid email formats' do
    valid_emails = [
      'user@domain.com',
      'test.email@domain.com',
      'user+tag@domain.com',
      'user123@domain123.com',
      'user@sub.domain.com',
      'user@domain-name.com',
      'user_name@domain.com',
      'user-name@domain.com',
      'user@domain.co.uk',
      'very.long.email.address@very.long.domain.name.com'
    ]

    valid_emails.each do |email|
      it "accepts #{email} as valid email" do
        tenant = PotentialTenant.new(valid_attributes.merge(email: email))
        expect(tenant).to be_valid
      end
    end
  end

  describe 'invalid email formats' do
    invalid_emails = [
      'plainaddress',
      'user@',
      '@domain.com',
      'user space@domain.com',
      'user@domain .com',
      'user@.com'
    ]

    invalid_emails.each do |email|
      it "rejects #{email} as invalid email" do
        tenant = PotentialTenant.new(valid_attributes.merge(email: email))
        expect(tenant).not_to be_valid
        expect(tenant.errors[:email]).to include('is invalid')
      end
    end
  end

  describe 'factory' do
    it 'creates a valid potential tenant' do
      tenant = build(:potential_tenant)
      expect(tenant).to be_valid
    end

    it 'creates potential tenant with unique email each time' do
      tenant1 = create(:potential_tenant)
      tenant2 = create(:potential_tenant)
      expect(tenant1.email).not_to eq(tenant2.email)
    end
  end
end
