import React, { useMemo } from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import Stack from '@mui/material/Stack';
import TextField from '@mui/material/TextField';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';

export const TenantDetails = ({
  selectedProperty,
  selectedSlot,
  selectedDate,
  setStep,
  onSubmit
}) => {
  const formattedDate = useMemo(() => selectedDate ? selectedDate.format('DD/MM/YYYY') : 'Not selected', [selectedDate]);

  const {
    startTime,
    endTime,
    day_of_week
  } = selectedSlot || {};

  const {
    address
  } = selectedProperty || {};

  return (
    <Box sx={{ background: '#fff', borderRadius: 3, boxShadow: 1, p: { xs: 2, md: 4 }, maxWidth: 1100, mx: 'auto', mt: 4 }}>
      <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ mb: 2 }}>
        <Box>
          <Typography variant="h5" fontWeight={700} sx={{ display: 'flex', alignItems: 'center', mb: 0.5 }}>
            <AccountCircleIcon sx={{ mr: 1 }} />
            Your Details
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Please provide your contact information
          </Typography>
        </Box>
        <Button variant="outlined" onClick={() => setStep(1)} sx={{ fontWeight: 600, borderRadius: 2 }}>
          Change Time
        </Button>
      </Stack>
      <Box sx={{ background: '#f2f7fe', borderRadius: 2, p: 2, mb: 3 }}>
        <Typography fontWeight={700} sx={{ mb: 1 }}>
          Booking Summary:
        </Typography>
        <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
          <LocationOnIcon color="primary" fontSize="small" />
          <Typography component="a" href="#" color="primary.dark" fontWeight={700} sx={{ textDecoration: 'underline', fontSize: 16 }}>
            {address}
          </Typography>
        </Stack>
        <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
          <CalendarTodayIcon color="primary" fontSize="small" />
          <Typography fontWeight={500}>{formattedDate} - {day_of_week}</Typography>
        </Stack>
        <Stack direction="row" alignItems="center" spacing={1}>
          <AccessTimeIcon color="primary" fontSize="small" />
          <Typography fontWeight={500}>{startTime} - {endTime}</Typography>
        </Stack>
      </Box>
      <Box component="form" onSubmit={onSubmit} autoComplete="off">
        <Stack spacing={2} sx={{ mb: 2 }}>
          <Stack direction={{ xs: 'column', md: 'row' }} spacing={2}>
            <TextField name="name" label="Full Name" fullWidth required placeholder="Enter your full name" variant="outlined" />
            <TextField name="email" label="Email Address" fullWidth required placeholder="Enter your email" variant="outlined" type="email" />
          </Stack>
          <TextField name="phone" label="Phone Number" fullWidth required placeholder="Enter your phone number" variant="outlined" type="number" />
          <TextField name="note" label="Additional Message (Optional)" fullWidth multiline minRows={3} placeholder="Any specific requirements or questions about the property..." variant="outlined" />
        </Stack>
        <Button type="submit" variant="contained" color="success" fullWidth sx={{ fontWeight: 700, fontSize: 18, py: 1.5, borderRadius: 2, textTransform: 'none' }}>
          Submit Booking Request
        </Button>
      </Box>
    </Box>
  );
};
