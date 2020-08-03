import { combineReducers } from 'redux';

import { reducers as statisticsPageReducers } from './Router/StatisticsPage';

const reducers = {
  foremanStatistics: combineReducers(statisticsPageReducers),
};

export default reducers;
