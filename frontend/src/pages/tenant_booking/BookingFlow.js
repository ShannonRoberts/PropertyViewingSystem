
import Stepper from '@mui/material/Stepper';
import Step from '@mui/material/Step';
import StepLabel from '@mui/material/StepLabel';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import { Link as RouterLink } from 'react-router-dom';
import { useBookingHooks } from './useBookingHooks';
import { SelectProperty } from './SelectProperty';
import { useCallback, useMemo } from 'react';
import { SelectAvailableTimeSlot } from './SelectAvailableTimeSlot';
import dayjs from 'dayjs';
import { TenantDetails } from './TenantDetails';
import { RequestSubmitted } from './RequestSubmitted';
import { useStateReducer } from '../../Utils';

export const BookingFlow = () => {
  const [state, setState] = useStateReducer({
    propertyId: null,
    step: 0,
    selectedDate: dayjs(),
    slot: null,
    details: {}
  });

  const { propertyId, step, selectedDate, slot, details } = state;

  const [{ properties, availability_slots }, { createViewing }] = useBookingHooks({ property_id: propertyId, selectedDate });

  const selectedProperty = useMemo(() => {
    return properties.find(prop => prop.id === propertyId);
  }, [properties, propertyId]);

  const selectedSlot = useMemo(() => {
    return availability_slots.find(as => as.id === slot);
  }, [availability_slots, slot]);

  const scheduledAt = useMemo(() => {
    if (!selectedSlot || !selectedDate) return null;
    return selectedDate
      .hour(Number(selectedSlot.startTime.split(':')[0]))
      .minute(Number(selectedSlot.startTime.split(':')[1]))
      .toDate();
  }, [selectedSlot, selectedDate]);

  const onSubmit = useCallback((e) => {
    e.preventDefault();
    const formData = new FormData(e.target);
    const viewingData = {
      potential_tenant: {
        name: formData.get('name'),
        email: formData.get('email'),
        phone: formData.get('phone'),
      },
      notes: formData.get('note'),
      property_id: propertyId,
      scheduled_at: scheduledAt,
      status: 'Requested'
    };
    setState({ details: viewingData });
    createViewing(viewingData);
    setState({ step: 3 });
  }, [setState, scheduledAt, propertyId, createViewing]);

  return (
    <Box sx={{ minHeight: '100vh', py: { xs: 2, md: 6 } }}>
      <Box sx={{ position: 'absolute', top: 16, left: 16, zIndex: 10 }}>
        <IconButton component={RouterLink} to="/" color="primary" size="large" aria-label="Back to home">
          <ArrowBackIcon />
        </IconButton>
      </Box>
      <Box sx={{ maxWidth: 1100, mx: 'auto', px: 2 }}>
        <Box>
          <Typography variant="h4" fontWeight={700} sx={{ mb: 0.2 }}>
            Book a Property Viewing
          </Typography>
          <Typography variant="subtitle1" color="text.secondary">
            Find and book your ideal viewing slot
          </Typography>
        </Box>
        <Stepper activeStep={step} alternativeLabel sx={{ mb: 4, mt: 4 }}>
          <Step key={0} onClick={() => setState({ step: 0 })}>
            <StepLabel>Select Property</StepLabel>
          </Step>
          <Step key={1} onClick={() => setState({ step: 1 })}>
            <StepLabel>Select Date & Time</StepLabel>
          </Step>
          <Step key={2} onClick={() => setState({ step: 2 })}>
            <StepLabel>Enter Details</StepLabel>
          </Step>
          <Step key={3} onClick={() => setState({ step: 3 })}>
            <StepLabel>Booking requested</StepLabel>
          </Step>
        </Stepper>
        {step === 0 && (
          <SelectProperty
            properties={properties}
            setPropertyId={(propertyId) => setState({ propertyId })}
            setStep={(step) => setState({ step })}
          />
        )}
        {step === 1 && (
          <SelectAvailableTimeSlot
            selectedProperty={selectedProperty}
            setStep={(step) => setState({ step })}
            selectedDate={selectedDate}
            setSelectedDate={(selectedDate) => setState({ selectedDate })}
            availability_slots={availability_slots}
            selectedSlot={slot}
            setSelectedSlot={(slot) => setState({ slot })} />
        )}
        {step === 2 && (
          <TenantDetails
            selectedProperty={selectedProperty}
            selectedDate={selectedDate}
            selectedSlot={selectedSlot}
            setStep={(step) => setState({ step })}
            onSubmit={onSubmit}
          />
        )}
        {step === 3 && (
          <RequestSubmitted
            details={details}
            property={selectedProperty}
            selectedDate={selectedDate}
            selectedSlot={selectedSlot}
            setDetails={(details) => setState({ details })}
            setStep={(step) => setState({ step })}
          />
        )}
      </Box>
    </Box>
  );
};
