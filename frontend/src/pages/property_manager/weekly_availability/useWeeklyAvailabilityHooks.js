import { useCallback, useEffect } from 'react';
import { useStateReducer } from '../../../Utils';

export const useWeeklyAvailabilityHooks = ({property_manager_id}) => {
  const [
    state,
    setState
  ] = useStateReducer(
    {
      availability_slots: [],
      properties: [],
      loading: false
    }
  );

  const fetchAvailabilitySlots = async () => {
    setState({ loading: true });
    try {
      const response = await fetch(`/api/v1/availability_slots?property_manager_id=${property_manager_id}`);
      if (!response.ok) {
        throw new Error('Failed to fetch availability slots');
      }
      const data = await response.json();
      setState({ availability_slots: Array.isArray(data) ? data : data.availability_slots || [] });
    } catch (error) {
      console.error('Error fetching availability slots:', error);
    } finally {
      setState({ loading: false });
    }
  };

  const fetchProperties = async () => {
    setState({ loading: true });
    try {
      const response = await fetch('/api/v1/properties');
      if (!response.ok) {
        throw new Error('Failed to fetch properties');
      }
      const { properties } = await response.json();
      setState({ properties });
    } catch (err) {
      console.error('Error fetching properties:', err);
    } finally {
      setState({ loading: false });
    }
  };

  useEffect(() => {
    fetchAvailabilitySlots();
    fetchProperties();
  }, []);

  console.log(state.properties);

  const createAvailabilitySlot = async (slot) => {
    setState({ loading: true });
    try {
      const response = await fetch('/api/v1/availability_slots', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(slot)
      });
      if (!response.ok) {
        throw new Error('Failed to create availability slot');
      }
      await fetchAvailabilitySlots();
    } catch (error) {
      console.error('Error creating availability slot:', error);
    } finally {
      setState({ loading: false });
    }
  };

  const addAvailabilitySlot = useCallback((slot) => {
    console.log(slot);
    createAvailabilitySlot(slot);
  }, [createAvailabilitySlot]);

  const deleteAvailabilitySlot = async (slotId) => {
    setState({ loading: true });
    try {
      const response = await fetch(`/api/v1/availability_slots/${slotId}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Failed to delete availability slot');
      }
      await fetchAvailabilitySlots();
    } catch (error) {
      console.error('Error deleting availability slot:', error);
    } finally {
      setState({ loading: false });
    }
  };

  const removeAvailabilitySlot = useCallback((slotId) => {
    deleteAvailabilitySlot(slotId);
  }, [deleteAvailabilitySlot]);

  const funcs = {
    addAvailabilitySlot,
    removeAvailabilitySlot
  };

  return [state, funcs];
};
