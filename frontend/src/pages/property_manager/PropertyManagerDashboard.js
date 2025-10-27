import Typography from '@mui/material/Typography';
import { WeeklyAvailability } from './weekly_availability/WeeklyAvailability';
import { UpcomingViewings } from './viewings/UpcomingViewings';
import Box from '@mui/material/Box';
import { PendingBookingRequests } from './viewings/PendingBookingRequests';
import { useViewingsHooks } from './viewings/useViewingsHooks';
import IconButton from '@mui/material/IconButton';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import { Link as RouterLink } from 'react-router-dom';
import './PropertyManagerDashboard.css';

export const PropertyManagerDashboard = () => {
  const property_manager_id = 1;
  const {
    viewings,
    updateViewing,
    deleteViewing,
    loading
  } = useViewingsHooks({ property_manager_id });

  return (
    <Box className="dashboard">
      <Box className="dashboard__back-button">
        <IconButton component={RouterLink} to="/" color="primary" size="large" aria-label="Back to home">
          <ArrowBackIcon />
        </IconButton>
      </Box>
      <Box className="dashboard__container">
        <Box className="dashboard__header">
          <Typography variant="h5">Property Manager Dashboard</Typography>
          <Typography variant="subtitle1" sx={{ mb: 3 }}>
            Manage your availability and bookings
          </Typography>
        </Box>
        <Box className="dashboard__layout">
          <Box className="dashboard__main-content">
            <WeeklyAvailability property_manager_id={property_manager_id} />
            <PendingBookingRequests
              viewings={viewings}
              updateViewing={updateViewing}
              deleteViewing={deleteViewing}
              loading={loading}
            />
          </Box>
          <Box className="dashboard__sidebar">
            <UpcomingViewings
              viewings={viewings}
              loading={loading}
            />
          </Box>
        </Box>
      </Box>
    </Box>
  );
};
