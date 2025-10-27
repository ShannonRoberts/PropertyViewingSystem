import React from 'react';
import Dialog from '@mui/material/Dialog';
import DialogTitle from '@mui/material/DialogTitle';
import DialogContent from '@mui/material/DialogContent';
import DialogActions from '@mui/material/DialogActions';
import Button from '@mui/material/Button';
import Checkbox from '@mui/material/Checkbox';
import FormControlLabel from '@mui/material/FormControlLabel';
import FormGroup from '@mui/material/FormGroup';
import TextField from '@mui/material/TextField';
import { LocalizationProvider, TimePicker } from '@mui/x-date-pickers';
import { AdapterDateFns } from '@mui/x-date-pickers/AdapterDateFns';
import Stack from '@mui/material/Stack';
import Typography from '@mui/material/Typography';
import IconButton from '@mui/material/IconButton';
import CloseIcon from '@mui/icons-material/Close';
import AddIcon from '@mui/icons-material/Add';
import Box from '@mui/material/Box';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import ListItemIcon from '@mui/material/ListItemIcon';

import { useStateReducer } from '../../../Utils';

const DAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];


export const AddAvailabilitySlotsModal = ({ open, onClose, properties = [], onAdd, property_manager_id }) => {
  const [state, setState] = useStateReducer({
    selectedDays: [],
    timeSlots: [{ start: null, end: null }],
    applyAll: false,
    selectedProperties: [],
    available: true
  });
  const { selectedDays, timeSlots, applyAll, selectedProperties, available } = state;

  const handleDayChange = (day) => {
    setState({
      selectedDays: selectedDays.includes(day)
        ? selectedDays.filter((d) => d !== day)
        : [...selectedDays, day]
    });
  };

  const handleTimeChange = (idx, field, value) => {
    setState({
      timeSlots: timeSlots.map((slot, i) => (i === idx ? { ...slot, [field]: value } : slot))
    });
  };

  const handleAddTimeSlot = () => {
    setState({ timeSlots: [...timeSlots, { start: null, end: null }] });
  };

  const handleRemoveTimeSlot = (idx) => {
    setState({ timeSlots: timeSlots.filter((_, i) => i !== idx) });
  };

  const handlePropertyChange = (id) => {
    setState({
      selectedProperties: selectedProperties.includes(id)
        ? selectedProperties.filter((pid) => pid !== id)
        : [...selectedProperties, id]
    });
  };

  const handleApplyAll = (e) => {
    if (e.target.checked) {
      setState({
        applyAll: true,
        selectedProperties: properties.map((p) => p.id)
      });
    } else {
      setState({
        applyAll: false,
        selectedProperties: []
      });
    }
  };

  const handleAdd = () => {
    onAdd({ selected_days: selectedDays, time_slots: timeSlots, selected_properties: selectedProperties, available, property_manager_id });
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <DialogTitle sx={{ fontWeight: 600, fontSize: 18, pb: 0 }}>
        Add Multiple Availability Slots
        <IconButton onClick={onClose} sx={{ position: 'absolute', right: 16, top: 16 }}>
          <CloseIcon />
        </IconButton>
      </DialogTitle>
      <DialogContent>
        <Typography variant="subtitle1" sx={{ mt: 2, mb: 1 }}>Days of Week</Typography>
        <FormGroup row>
          {DAYS.map((day) => (
            <FormControlLabel
              key={day}
              control={<Checkbox checked={selectedDays.includes(day)} onChange={() => handleDayChange(day)} />}
              label={day}
            />
          ))}
        </FormGroup>
        <Typography variant="h6" sx={{ mt: 3, mb: 1 }}>Time Slots</Typography>
        <LocalizationProvider dateAdapter={AdapterDateFns}>
          <Stack spacing={1}>
            {timeSlots.map((slot, idx) => (
              <Stack direction="row" spacing={1} alignItems="center" key={idx}>
                <TimePicker
                  label="Start Time"
                  value={slot.start}
                  onChange={value => handleTimeChange(idx, 'start', value)}
                  renderInput={(params) => <TextField {...params} size="small" />}
                />
                <TimePicker
                  label="End Time"
                  value={slot.end}
                  onChange={value => handleTimeChange(idx, 'end', value)}
                  renderInput={(params) => <TextField {...params} size="small" />}
                />
                <IconButton onClick={() => handleRemoveTimeSlot(idx)} disabled={timeSlots.length === 1}>
                  <CloseIcon />
                </IconButton>
              </Stack>
            ))}
            <Button startIcon={<AddIcon />} onClick={handleAddTimeSlot} sx={{ alignSelf: 'flex-start' }}>
              Add Time Slot
            </Button>
          </Stack>
        </LocalizationProvider>
        <Typography variant="h6" sx={{ mt: 3, mb: 1 }}>Properties</Typography>
        <FormControlLabel
          control={<Checkbox checked={applyAll} onChange={handleApplyAll} />}
          label="Apply to all properties"
        />
        <Box sx={{ maxHeight: 120, overflow: 'auto', border: '1px solid #eee', borderRadius: 1, mb: 1 }}>
          <List dense>
            {properties.map((prop) => (
              <ListItem key={prop.id} disablePadding>
                <ListItemIcon>
                  <Checkbox
                    edge="start"
                    checked={selectedProperties.includes(prop.id)}
                    onChange={() => handlePropertyChange(prop.id)}
                    disabled={applyAll}
                  />
                </ListItemIcon>
                <ListItemText primary={prop.label || prop.address} />
              </ListItem>
            ))}
          </List>
        </Box>
        <FormControlLabel
          control={<Checkbox checked={available} onChange={e => setState({ available: e.target.checked })} />}
          label="Available for bookings"
        />
      </DialogContent>
      <DialogActions sx={{ px: 3, pb: 2 }}>
        <Button onClick={onClose} variant="outlined" sx={{ minWidth: 120 }}>Cancel</Button>
        <Button onClick={handleAdd} variant="contained" sx={{ minWidth: 160 }}>
          Add {selectedDays.length * timeSlots.length} Slot{selectedDays.length * timeSlots.length !== 1 ? 's' : ''}
        </Button>
      </DialogActions>
    </Dialog>
  );
};
