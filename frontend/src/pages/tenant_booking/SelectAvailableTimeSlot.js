import Box from '@mui/material/Box';
import Grid from '@mui/material/Grid';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import Stack from '@mui/material/Stack';
import Card from '@mui/material/Card';
import Chip from '@mui/material/Chip';
import CalendarTodayIcon from '@mui/icons-material/CalendarToday';
import { DatePicker } from '@mui/x-date-pickers/DatePicker';
import { useCallback } from 'react';
import './SelectAvailableTimeSlot.css';

export const SelectAvailableTimeSlot = ({ selectedProperty, setStep, selectedDate, setSelectedDate, availability_slots, setSelectedSlot }) => {

  const selectSlot = useCallback((slotId) => {
    setSelectedSlot(slotId);
    setStep(2);
  }, [setSelectedSlot, setStep]);

  return (
    <Box sx={{ background: '#fff', borderRadius: 3, boxShadow: 1, p: { xs: 2, md: 4 }, maxWidth: 1100, mx: 'auto', mt: 4 }}>
      <Stack direction="row" justifyContent="space-between" alignItems="center" sx={{ mb: 2 }}>
        <Box>
          <Typography variant="h5" fontWeight={700} sx={{ display: 'flex', alignItems: 'center', mb: 0.5 }}>
            <CalendarTodayIcon sx={{ mr: 1, color: 'primary.main' }} />
            Select a Time Slot
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Choose from available viewing times
          </Typography>
        </Box>
        <Button variant="outlined" onClick={() => setStep(0)} sx={{ fontWeight: 600, borderRadius: 2 }}>
          Change Property
        </Button>
      </Stack>
      <Box sx={{ background: '#f2f7fe', borderRadius: 2, p: 2, mb: 3 }}>
        <Typography fontWeight={700} color="primary.main" sx={{ mb: 0.5 }}>
          Selected Property:
        </Typography>
        <Typography component="a" href="#" color="primary.dark" fontWeight={700} sx={{ textDecoration: 'underline', fontSize: 18 }}>
          {selectedProperty?.address || '123 Oak Street, Downtown'}
        </Typography>
      </Box>
      <Box sx={{ mb: 3 }}>
        <DatePicker
          label="Pick a date"
          value={selectedDate}
          onChange={setSelectedDate}
          disablePast={true}
          sx={{ background: '#fff', borderRadius: 2 }}
        />
      </Box>
      <Stack spacing={3}>
        {!selectedDate ? (
          <Typography variant="body1" color="text.secondary" sx={{ textAlign: 'center', py: 4 }}>
            Please select a date.
          </Typography>
        ) : availability_slots.length === 0 ? (
          <Typography variant="body1" color="text.secondary" sx={{ textAlign: 'center', py: 4 }}>
            There are no slots available for this date. Please pick another date.
          </Typography>
        ) : (
          <Box sx={{ flexGrow: 1 }}>
            <Grid container spacing={3}>
              {availability_slots.map(({id, day_of_week, startTime, endTime}) => (
                <Grid item xs={12} sm={6} md={4} lg={3} key={id}>
                  <Card
                    variant="outlined"
                    onClick={() => selectSlot(id)}
                    className={'availability-slot'}
                  >
                    <Box sx={{ mr: 10 }}>
                      <Typography fontWeight={700} sx={{ fontSize: 18 }}>{day_of_week}</Typography>
                      <Typography sx={{ fontSize: 16 }}>{startTime} - {endTime}</Typography>
                    </Box>
                    <Chip label="Available" sx={{ bgcolor: '#d6f5e6', color: 'green', fontWeight: 700 }} />
                  </Card>
                </Grid>
              ))}
            </Grid>
          </Box>
        )}
      </Stack>
    </Box>
  );
};
