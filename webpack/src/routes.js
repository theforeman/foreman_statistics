import React from 'react'
import StatisticsPage from './Pages/StatisticsPage';

const routes = [
  {
    path: '/foreman_statistics/statistics',
    exact: true,
    render: props => <StatisticsPage {...props} />,
  },
];

export default routes;
