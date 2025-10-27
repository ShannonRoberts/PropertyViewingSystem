import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Stack from '@mui/material/Stack';
import Card from '@mui/material/Card';
import Button from '@mui/material/Button';
import { useCallback } from 'react';
import './SelectProperty.css';

export const SelectProperty = ({ properties, setPropertyId, setStep }) => {
  const selectProperty = useCallback((propertyId) => {
    setPropertyId(propertyId);
    setStep(1);
  }, [setPropertyId, setStep]);
  return (
    <Box sx={{ background: '#f2f4fa', borderRadius: 3, boxShadow: 1, p: { xs: 2, md: 4 }, mt: 2 }}>
      <Typography variant="h6" fontWeight={700} sx={{ mb: 0.5, display: 'flex', alignItems: 'center' }}>
        Select a Property
      </Typography>
      <Typography variant="body2" color="text.secondary" sx={{ mb: 4 }}>
        Choose the property you would like to view
      </Typography>
      {properties.length === 0 ? (
        <Typography variant="body1" color="text.secondary" sx={{ textAlign: 'center', py: 4 }}>
          No properties currently available.
        </Typography>
      ) : (
        <Stack spacing={3} sx={{ width: '100%' }}>
          {Array.from({ length: Math.ceil(properties?.length / 2) }).map((_, rowIdx) => (
            <Stack key={rowIdx} direction={{ xs: 'column', md: 'row' }} spacing={3} sx={{ width: '100%' }}>
              {properties.slice(rowIdx * 2, rowIdx * 2 + 2).map(({id, address, price, bedrooms, bathrooms, square_feet, description}) => (
                <Box key={id} sx={{ flex: 1, minWidth: 0 }}>
                  <Card
                    variant={'outlined'}
                    className="property-card"
                  >
                    <Typography fontWeight={700} sx={{ fontSize: 20, mb: 0.5 }}>{address}</Typography>
                    <Typography fontWeight={700} sx={{ color: 'primary.main', fontSize: 18, mb: 1 }}>
                      ${price.toLocaleString()}/month
                    </Typography>
                    <Stack direction="row" spacing={2} sx={{ mb: 2 }}>
                      <Typography variant="body2" color="text.secondary">{bedrooms} bed</Typography>
                      <Typography variant="body2" color="text.secondary">{bathrooms} bath</Typography>
                      <Typography variant="body2" color="text.secondary">{square_feet} square feet</Typography>
                    </Stack>
                    <Typography variant="body2" color="text.secondary">{description}</Typography>
                    <Button
                      fullWidth
                      variant={'contained'}
                      color="primary"
                      sx={{ fontWeight: 600, borderRadius: 2, py: 1, fontSize: 16, mt: 2 }}
                      onClick={() => selectProperty(id)}
                    >
                      Select Property
                    </Button>
                  </Card>
                </Box>
              ))}
              {/* If odd number of properties, fill last row with empty box for alignment */}
              {properties?.length % 2 !== 0 && rowIdx === Math.floor(properties?.length / 2) && (
                <Box sx={{ flex: 1, minWidth: 0 }} />
              )}
            </Stack>
          ))}
        </Stack>
      )}
    </Box>
  );
};
