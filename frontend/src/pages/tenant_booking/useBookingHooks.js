import { useCallback, useEffect } from 'react';
import { useStateReducer } from '../../Utils';

export const useBookingHooks = ({property_id, selectedDate}) => {
  const [
    state,
    setState
  ] = useStateReducer(
    {
      availability_slots: [],
      properties: [],
      loading: false
    }
  );

  const fetchProperties = async () => {
    setState({ loading: true });
    try {
      const response = await fetch('/api/v1/properties');
      if (!response.ok) {
        throw new Error('Failed to fetch properties');
      }
      const { properties } = await response.json();
      setState({ properties });
    } catch (err) {
      console.error('Error fetching properties:', err);
    } finally {
      setState({ loading: false });
    }
  };

  const fetchAvailabilitySlots = useCallback(async () => {
    setState({ loading: true });
    try {
      const response = await fetch(`/api/v1/availability_slots?property_id=${property_id}&date=${encodeURIComponent(selectedDate)}`);
      if (!response.ok) {
        throw new Error('Failed to fetch availability slots');
      }
      const availability_slots = await response.json();
      const mappedSlots = availability_slots.map(slot => ({
        startTime: new Date(slot?.start_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        endTime: new Date(slot?.end_time).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
        ...slot
      }));
      setState({ availability_slots: mappedSlots || [] });
    } catch (error) {
      console.error('Error fetching availability slots:', error);
    } finally {
      setState({ loading: false });
    }
  }, [property_id, setState, selectedDate]);

  useEffect(() => {
    fetchProperties();
    if (property_id) fetchAvailabilitySlots();
  }, [property_id, fetchAvailabilitySlots]);

  // Create a new viewing
  const createViewing = async (viewing) => {
    setState({ loading: true });
    try {
      const response = await fetch('/api/v1/viewings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ viewing })
      });
      if (!response.ok) {
        throw new Error('Failed to create viewing');
      }
      // Optionally, you could fetch viewings or update state here if needed
      return await response.json();
    } catch (error) {
      console.error('Error creating viewing:', error);
      throw error;
    } finally {
      setState({ loading: false });
    }
  };

  const funcs = {
    createViewing,
  };

  return [state, funcs];
};
