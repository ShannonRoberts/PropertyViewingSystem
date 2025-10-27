
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import ApartmentIcon from '@mui/icons-material/Apartment';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import SupervisorAccountIcon from '@mui/icons-material/SupervisorAccount';
import PersonIcon from '@mui/icons-material/Person';
import { Link as RouterLink } from 'react-router-dom';
import './LandingPage.css';

export const LandingPage = () => {

  return (
    <Box className="landing-page">
      <Box className="landing-page__header">
        <ApartmentIcon sx={{ fontSize: 48, color: 'primary.main', mr: 1 }} />
        <Typography variant="h3" fontWeight={700} color="primary.main">
          Property Viewing Scheduler
        </Typography>
      </Box>
      <Typography variant="h5" sx={{ mb: 4, maxWidth: 600, textAlign: 'center' }}>
        Effortlessly manage property viewings, availability, and booking requests
      </Typography>
      <Box className="landing-page__cards-container">
        <Card className="landing-page__card">
          <SupervisorAccountIcon sx={{ fontSize: 44, color: 'primary.main', mb: 1 }} />
          <CardContent className="landing-page__card-content">
            <Typography variant="h5" fontWeight={600} sx={{ mb: 1 }}>
              Property Manager
            </Typography>
            <Typography variant="body1" sx={{ mb: 2 }}>
              Manage your properties, set your weekly availability, and approve or decline booking requests from potential tenants.
            </Typography>
            <Button
              variant="contained"
              color="primary"
              size="large"
              sx={{ px: 4, py: 1, fontWeight: 600, borderRadius: 2 }}
              className="landing-page__card-button"
              component={RouterLink}
              to="/dashboard"
            >
              Go to dashboard
            </Button>
          </CardContent>
        </Card>
        <Card className="landing-page__card">
          <PersonIcon sx={{ fontSize: 44, color: 'secondary.main', mb: 1 }} />
          <CardContent className="landing-page__card-content">
            <Typography variant="h5" fontWeight={600} sx={{ mb: 1 }}>
              Tenant
            </Typography>
            <Typography variant="body1" sx={{ mb: 2 }}>
              Browse available properties, request viewings, and manage your upcoming appointments with ease.
            </Typography>
            <Button
              variant="outlined"
              color="primary"
              size="large"
              sx={{ px: 4, py: 1, fontWeight: 600, borderRadius: 2 }}
              className="landing-page__card-button"
              component={RouterLink}
              to="/book-viewing"
            >
              Book a viewing
            </Button>
          </CardContent>
        </Card>
      </Box>
    </Box>
  );
};
