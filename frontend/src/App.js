import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { LandingPage } from './pages/LandingPage';
import { PropertyManagerDashboard } from './pages/property_manager/PropertyManagerDashboard';
import { BookingFlow } from './pages/tenant_booking/BookingFlow';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';

function App() {
  return (
    <LocalizationProvider dateAdapter={AdapterDayjs}>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<LandingPage />} />
          <Route path="/dashboard" element={<PropertyManagerDashboard />} />
          <Route path="/book-viewing" element={<BookingFlow />} />
        </Routes>
      </BrowserRouter>
    </LocalizationProvider>
  );
}

export default App;
