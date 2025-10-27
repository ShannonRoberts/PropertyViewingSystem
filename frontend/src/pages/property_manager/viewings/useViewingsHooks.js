import { useEffect } from 'react';
import { useStateReducer } from '../../../Utils';
import { useCallback } from 'react';

export const useViewingsHooks = ({ property_manager_id }) => {
  const [state, setState] = useStateReducer({
    viewings: [],
    loading: false,
  });

  const fetchViewings = async () => {
    setState({ loading: true });
    try {
      const params = new URLSearchParams({ property_manager_id });
      const response = await fetch(`/api/v1/viewings?${params.toString()}`);
      if (!response.ok) {
        throw new Error('Failed to fetch viewings');
      }
      const viewings = await response.json();
      const formattedViewings = viewings.map((v) => {
        const dateObj = new Date(v.scheduled_at);
        return {
          ...v,
          date: dateObj.toLocaleDateString(undefined, {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
          }),
          time: dateObj.toLocaleTimeString(undefined, {
            hour: 'numeric',
            minute: '2-digit',
            hour12: true,
          }).toLowerCase()
        };
      });
      setState({ viewings: formattedViewings || [] });
    } catch (error) {
      console.error('Error fetching viewings:', error);
    } finally {
      setState({ loading: false });
    }
  };

  useEffect(() => {
    fetchViewings();
  }, [property_manager_id]);

  const updateViewing = useCallback(async (id, updates) => {
    setState({ loading: true });
    try {
      const response = await fetch(`/api/v1/viewings/${id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ viewing: updates })
      });
      if (!response.ok) {
        throw new Error('Failed to update viewing');
      }
      const updated = await response.json();
      setState((prev) => ({
        ...prev,
        viewings: prev.viewings.map((v) => v.id === updated.id ? { ...v, ...updated } : v),
        loading: false
      }));
      return updated;
    } catch (error) {
      setState({ loading: false });
      console.error('Error updating viewing:', error);
      throw error;
    }
  }, [setState]);

  const deleteViewing = useCallback(async (id) => {
    setState({ loading: true });
    try {
      const response = await fetch(`/api/v1/viewings/${id}`, {
        method: 'DELETE'
      });
      if (!response.ok) {
        throw new Error('Failed to delete viewing');
      }
      setState((prev) => ({
        ...prev,
        viewings: prev.viewings.filter((v) => v.id !== id),
        loading: false
      }));
    } catch (error) {
      setState({ loading: false });
      console.error('Error deleting viewing:', error);
      throw error;
    }
  }, [setState]);

  return { ...state, updateViewing, deleteViewing };
};
