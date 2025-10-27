import { useCallback, useMemo } from 'react';
import Card from '@mui/material/Card';
import Typography from '@mui/material/Typography';
import Stack from '@mui/material/Stack';
import Box from '@mui/material/Box';
import Button from '@mui/material/Button';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import AccessTimeIcon from '@mui/icons-material/AccessTime';

export const PendingBookingRequests = (props) => {
  const { viewings, updateViewing, deleteViewing } = props;

  const requestedViewings = useMemo(() =>
    viewings.filter((v) => v.status === 'Requested'),
  [viewings]
  );

  const onConfirm = useCallback((viewingId) => {
    updateViewing(viewingId, { status: 'Scheduled' });
  }, [updateViewing]);

  const onDecline = useCallback((viewingId) => {
    deleteViewing(viewingId);
  }, [deleteViewing]);

  return (
    <Card sx={{ p: 1.5, borderRadius: 2, boxShadow: 0, background: '#f2f4fa', border: '1.5px solid #e1e4f0', minWidth: 350 }}>
      <Stack spacing={0.5}>
        <Stack direction="row" alignItems="center" spacing={0.5}>
          <AccessTimeIcon sx={{ color: 'primary.main', fontSize: 20, mr: 0.5 }} />
          <Typography fontWeight={600} sx={{ fontSize: 18 }}>
            Pending Booking Requests
          </Typography>
        </Stack>
        <Typography variant="caption" color="text.secondary" sx={{ mb: 1, fontSize: 14 }}>
          Review and approve incoming booking requests
        </Typography>
        {requestedViewings.length === 0 ? (
          <Box sx={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            py: 4,
            my: 2,
            background: '#f8fafd',
            borderRadius: 2,
            border: '1px dashed #b6c2d1',
          }}>
            <Box sx={{ fontSize: 38, color: 'primary.light', mb: 1 }}>
              <CalendarMonthIcon fontSize="inherit" color="disabled" />
            </Box>
            <Typography variant="h6" sx={{ color: 'text.secondary', fontWeight: 500, mb: 0.5 }}>
              No viewing requested
            </Typography>
            <Typography variant="body2" sx={{ color: 'text.secondary', opacity: 0.7 }}>
              You&apos;re all caught up!
            </Typography>
          </Box>
        ) : (
          requestedViewings.map(({id, date, time, potential_tenant: {name, email} = {}, property: { address } ={}}) => (
            <Card key={id} variant="outlined" sx={{ borderRadius: 1.5, mb: 1, p: 1, position: 'relative', bgcolor: '#fff', borderColor: 'secondary.main' }}>
              <Stack spacing={0.5}>
                <Typography variant="caption" fontWeight={600} sx={{ fontSize: '0.9rem' }}>{name}</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ fontSize: '0.7rem' }}>{email}</Typography>
                <Typography variant="caption" color="text.secondary" sx={{ fontSize: '0.7rem' }}>{address}</Typography>
                <Stack direction="row" alignItems="center" spacing={1}>
                  <Stack direction="row" alignItems="center" spacing={0.25}>
                    <CalendarMonthIcon fontSize="small" color="action" />
                    <Typography variant="caption" sx={{ fontSize: '0.7rem' }}>{date}</Typography>
                  </Stack>
                  <Stack direction="row" alignItems="center" spacing={0.25}>
                    <AccessTimeIcon fontSize="small" color="action" />
                    <Typography variant="caption" sx={{ fontSize: '0.7rem' }}>{time}</Typography>
                  </Stack>
                </Stack>
                <Stack direction="row" spacing={1} sx={{ mt: 1 }}>
                  <Button variant="contained" sx={{ fontWeight: 600, px: 1.5, borderRadius: 1.5, fontSize: '0.7rem', minWidth: 60, height: 24 }} onClick={() => onConfirm(id)}>
                    Confirm
                  </Button>
                  <Button variant="outlined" color="error" sx={{ fontWeight: 600, px: 1.5, borderRadius: 1.5, fontSize: '0.7rem', minWidth: 60, height: 24 }} onClick={() => onDecline(id)}>
                    Decline
                  </Button>
                </Stack>
              </Stack>
              <Box sx={{ position: 'absolute', top: 8, right: 8, bgcolor: '#fff9db', px: 1, py: 0.1, borderRadius: 1, fontWeight: 600, color: '#a67c00', fontSize: 10 }}>
                Requested
              </Box>
            </Card>
          ))
        )}
      </Stack>
    </Card>
  );
};
