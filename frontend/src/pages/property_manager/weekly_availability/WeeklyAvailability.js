import Button from '@mui/material/Button';
import Card from '@mui/material/Card';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import AddIcon from '@mui/icons-material/Add';
import DeleteIcon from '@mui/icons-material/Delete';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import { useWeeklyAvailabilityHooks } from './useWeeklyAvailabilityHooks';
import { useMemo, useState } from 'react';
import { AddAvailabilitySlotsModal } from './AddAvailabilitySlotsModal';
import Box from '@mui/material/Box';

export const WeeklyAvailability = ({ property_manager_id }) => {
  // Notes: In future ild make it so the user could click available to easily set it to unavailable
  // I would also group the same timeslots for multiple properties, but for now this is a simple implementation
  // I have time timeslots for multiple properties but when the a property timeslot gets booked/requested the same timeslot for other properties wont show (if the viewings are on the same day)

  const [state, funcs] = useWeeklyAvailabilityHooks({ property_manager_id});

  const { availability_slots, properties } = state;
  const { addAvailabilitySlot, removeAvailabilitySlot } = funcs;

  const [modalOpen, setModalOpen] = useState(false);

  const mappedSlots = useMemo(() =>
    availability_slots.map(slot => ({
      startTime: new Date(slot?.start_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      endTime: new Date(slot?.end_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
      ...slot
    })),
  [availability_slots]
  );

  return (
    <div style={{ display: 'flex', flexDirection: 'column', flexGrow: 1, width: '100%', height: '100%' }}>
      <Card sx={{ p: 1.5, borderRadius: 2, boxShadow: 0, background: '#f2f4fa', border: '1.5px solid #e1e4f0', minWidth: 350   }}>
        <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 1, width: '100%' }}>
          <AccessTimeIcon color="primary" fontSize="small" />
          <Typography fontWeight={600} sx={{ fontSize: 18 }}>
            Weekly Availability
          </Typography>
          <Stack direction="row" sx={{ flexGrow: 1 }} />
          <Button
            variant="contained"
            startIcon={<AddIcon fontSize="small" />}
            sx={{ ml: 'auto', fontSize: '0.85rem', py: 0.5, px: 1.5, minHeight: 32, borderRadius: 1.5, textTransform: 'none' }}
            onClick={() => setModalOpen(true)}
          >
            Add Slot
          </Button>
        </Stack>
        <Typography variant="body2" color="text.secondary" sx={{ mb: 2, fontSize: '0.95rem', textTransform: 'none' }}>
          Set your available time slots for property viewings
        </Typography>
        <Stack spacing={2}>
          {mappedSlots.length === 0 && (
            <Typography color="text.secondary" variant="body2" sx={{ fontSize: '0.95rem', textTransform: 'none' }}>No availability slots set.</Typography>
          )}
          {mappedSlots.map((slot, index) => (
            <Card key={index} variant="outlined" sx={{ borderRadius: 2, px: 2, py: 1, borderColor: 'secondary.main' }}>
              <Box sx={{ display: 'flex', alignItems: 'center', width: '100%' }}>
                <Typography variant="body1" sx={{ minWidth: 90, fontSize: '1rem', mr: 2, textTransform: 'none' }}>
                  {slot.day_of_week}
                </Typography>
                <Typography variant="body2" sx={{ fontWeight: 500, minWidth: 100, fontSize: '0.95rem', mr: 2, textTransform: 'none' }}>
                  {slot.startTime} - {slot.endTime}
                </Typography>
                <Typography
                  variant="caption"
                  sx={{
                    borderRadius: 2,
                    px: 2,
                    fontWeight: 600,
                    minWidth: 80,
                    fontSize: '0.9rem',
                    color: slot.available !== false && slot.is_available !== false ? 'primary.main' : 'text.secondary',
                    borderColor: slot.available !== false && slot.is_available !== false ? 'secondary.main' : 'grey.100',
                    textAlign: 'center',
                    textTransform: 'none',
                  }}
                >
                  {slot.available !== false && slot.is_available !== false ? 'Available' : 'Unavailable'}
                </Typography>
                <Button color="error" size="small" sx={{ minWidth: 0, ml: 'auto', textTransform: 'none' }} onClick={() => removeAvailabilitySlot(slot.id)}>
                  <DeleteIcon fontSize="small" />
                </Button>
              </Box>
              <Typography variant="caption" sx={{ color: 'text.secondary', fontSize: '0.78rem', mt: 0.5, textAlign: 'left' }}>
                {slot.property?.address}
              </Typography>
            </Card>
          ))}
        </Stack>
      </Card>
      <AddAvailabilitySlotsModal
        open={modalOpen}
        onClose={() => setModalOpen(false)}
        properties={properties}
        property_manager_id={property_manager_id}
        onAdd={(data) => {
          addAvailabilitySlot(data);
          setModalOpen(false);
        }}
      />
    </div>
  );
};
