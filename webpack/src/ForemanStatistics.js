import React from 'react';
import { BrowserRouter } from 'react-router-dom';
import ForemanStatisticsRoute from './Router';

const ForemanStatistics = () => (
  <BrowserRouter>
    <ForemanStatisticsRoute />
  </BrowserRouter>
);

export default ForemanStatistics;
