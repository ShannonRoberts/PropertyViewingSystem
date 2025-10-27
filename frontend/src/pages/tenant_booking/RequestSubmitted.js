import React from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Stack from '@mui/material/Stack';
import Button from '@mui/material/Button';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import EmailIcon from '@mui/icons-material/Email';

export const RequestSubmitted = ({
  details = {},
  property = {},
  selectedDate = null,
  selectedSlot = {},
  setStep
}) => {
  const {
    potential_tenant: { name, email } = {}
  } = details;

  const { address } = property;
  const formattedDate = selectedDate ? selectedDate.format('YYYY-MM-DD') : '';
  const formattedTime = selectedSlot ? `${selectedSlot.startTime} - ${selectedSlot.endTime}` : '';

  return (
    <Box sx={{ background: '#fff', borderRadius: 3, boxShadow: 1, p: { xs: 2, md: 4 }, maxWidth: 1100, mx: 'auto', mt: 4 }}>
      <Stack spacing={2}>
        <Stack direction="row" alignItems="center" spacing={1}>
          <CheckCircleIcon color="success" sx={{ fontSize: 36 }} />
          <Typography variant="h5" fontWeight={700} color="success.main">
            Booking Request Submitted
          </Typography>
        </Stack>
        <Typography color="text.secondary">
          Your viewing request has been sent to the property manager
        </Typography>
        <Box sx={{ background: '#f0fcf4', borderRadius: 2, p: 2, mb: 2 }}>
          <Typography fontWeight={700} sx={{ mb: 1 }}>
            Booking Details:
          </Typography>
          <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
            <LocationOnIcon color="success" fontSize="small" />
            <Typography fontWeight={700}>Property:</Typography>
            <Typography>{address}</Typography>
          </Stack>
          <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
            <CalendarTodayIcon color="success" fontSize="small" />
            <Typography fontWeight={700}>Date:</Typography>
            <Typography>{formattedDate}</Typography>
          </Stack>
          <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
            <AccessTimeIcon color="success" fontSize="small" />
            <Typography fontWeight={700}>Time:</Typography>
            <Typography>{formattedTime}</Typography>
          </Stack>
          <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
            <Typography fontWeight={700}>Name:</Typography>
            <Typography>{name}</Typography>
          </Stack>
          <Stack direction="row" alignItems="center" spacing={1}>
            <EmailIcon color="success" fontSize="small" />
            <Typography fontWeight={700}>Email:</Typography>
            <Typography>{email}</Typography>
          </Stack>
        </Box>
        <Box sx={{ background: '#f2f7fe', borderRadius: 2, p: 2, mb: 2 }}>
          <Typography fontWeight={700} color="primary.dark" sx={{ mb: 1 }}>
            What happens next?
          </Typography>
          <Typography color="primary" component="ul" sx={{ pl: 2, m: 0 }}>
            <li>The property manager will review your request</li>
            <li>You&apos;ll receive a confirmation email within 24 hours</li>
            <li>If approved, you&apos;ll get viewing details and contact information</li>
            <li>A reminder will be sent before your viewing appointment</li>
          </Typography>
        </Box>
        <Stack direction={{ xs: 'column', md: 'row' }} spacing={2} sx={{ mt: 2 }}>
          <Button variant="outlined" color="inherit" fullWidth onClick={() => setStep(0)} sx={{ fontWeight: 600, fontSize: 16, py: 1.2, borderRadius: 2 }}>
            Book Another Viewing
          </Button>
          <Button variant="contained" color="primary" fullWidth href="/" sx={{ fontWeight: 600, fontSize: 16, py: 1.2, borderRadius: 2 }}>
            Back to Home
          </Button>
        </Stack>
      </Stack>
    </Box>
  );
};
