// This example for extanding foreman-core's component via slot&fill
import { registerRoutes } from 'foremanReact/routes/RoutingService';
import registerReducer from 'foremanReact/redux/reducers/registerReducer';
import ForemanStatisticsRoutes from './src/routes';
import reducers from './src/reducers';
/*
import React from 'react';
import { addGlobalFill } from 'foremanReact/components/common/Fill/GlobalFill';

addGlobalFill('slotId', 'fillId', <SomeComponent key="some-key" />, 300);

addGlobalFill(
  'slotId',
  'fillId',
  { someProp: 'this is an override prop' },
  300
);
*/


// register reducers
Object.entries(reducers).forEach(([key, reducer]) =>
  registerReducer(key, reducer)
);

registerRoutes('ForemanStatistics', ForemanStatisticsRoutes);
