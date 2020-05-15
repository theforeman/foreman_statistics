import { combineReducers } from 'redux';
import EmptyStateReducer from './Components/EmptyState/EmptyStateReducer';

const reducers = {
  pluginTemplate: combineReducers({
    emptyState: EmptyStateReducer,
  }),
};

export default reducers;
