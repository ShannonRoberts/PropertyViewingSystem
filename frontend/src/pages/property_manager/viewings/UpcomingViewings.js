import Card from '@mui/material/Card';
import Typography from '@mui/material/Typography';
import Stack from '@mui/material/Stack';
import Box from '@mui/material/Box';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import { useMemo } from 'react';

export const UpcomingViewings = ({viewings}) => {

  const filteredViewings = useMemo(() =>
    viewings.filter((v) => v.status === 'Scheduled'),
  [viewings]
  );

  return (<Card sx={{ p: 2, borderRadius: 2, boxShadow: 0, background: '#f7fcfa', border: '1.5px solid #e3f1ea', minWidth: 350 }}>
    <Stack direction="row" alignItems="center" spacing={1} sx={{ mb: 0.5 }}>
      <CalendarMonthIcon sx={{ color: '#1db954', fontSize: 22 }} />
      <Typography fontWeight={600} sx={{ fontSize: 18 }}>
        Upcoming Viewings
      </Typography>
    </Stack>
    <Typography sx={{ mb: 1, fontSize: 13 }}>
      Your confirmed appointments
    </Typography>
    <Stack spacing={1.2}>
      {filteredViewings.map(({ id, date, time, status, property: { address } = {}, potential_tenant: { name } = {} }) => (
        <Box key={id} sx={{ border: '1.5px solid #e3f1ea', borderRadius: 2, p: 1.2, background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <Box>
            <Typography fontWeight={600} sx={{ mb: 0.2, fontSize: 15 }}>{name}</Typography>
            <Typography sx={{ mb: 0.5, fontSize: 13 }}>{address}</Typography>
            <Stack direction="row" alignItems="center" spacing={1} sx={{width: '100%'}}>
              <CalendarMonthIcon sx={{ fontSize: 15 }} />
              <Typography sx={{ fontSize: 12 }}>{date}</Typography>
              <AccessTimeIcon sx={{ fontSize: 15, ml: 2 }} />
              <Typography sx={{ fontSize: 12 }}>{time}</Typography>
            </Stack>
          </Box>
          <Box sx={{ ml: 2 }} >
            <Typography sx={{ background: '#e6f7ec', color: '#2e7d4f', px: 1.5, py: 0.2, borderRadius: 2, fontWeight: 600, fontSize: 13 }}>
              {status}
            </Typography>
          </Box>
        </Box>
      ))}
    </Stack>
  </Card>
  );
};
