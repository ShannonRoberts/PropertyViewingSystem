import * as React from 'react';
import { ThemeProvider, CssBaseline } from '@mui/material';
import theme from './theme';

export default function ThemeProviderWrapper({ children }) {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      {children}
    </ThemeProvider>
  );
}
