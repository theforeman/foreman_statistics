import { combineReducers } from 'redux';

import statisticsPageReducers from './Pages/StatisticsPage/reducers';

const reducers = {
  foremanStatistics: combineReducers(statisticsPageReducers),
};

export default reducers;
