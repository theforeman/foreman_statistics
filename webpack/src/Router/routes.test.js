import React from 'react';
import { Provider } from 'react-redux';
import { shallow } from '@theforeman/test';

import { statisticsProps } from './StatisticsPage/StatisticsPage.fixtures';
import Routes from './routes';

describe('ForemanPluginTemplateRoutes', () => {
  it('should create routes', () => {
    Object.entries(Routes).forEach(([key, Route]) => {
      const store = {
        subscribe: jest.fn(),
        dispatch: jest.fn(),
        getState: () => statisticsProps,
      };
      const RouteComponent = shallow(
        <Provider store={store}>
          <Route.component history={{}} some="props" />
        </Provider>
      );
      Route.renderResult = RouteComponent;
    });

    expect(Routes).toMatchSnapshot();
  });
});
