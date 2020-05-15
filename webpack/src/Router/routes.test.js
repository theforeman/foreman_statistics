import React from 'react';
import { shallow } from '@theforeman/test';

import Routes from './routes';

describe('PluginTemplateRoutes', () => {
  it('should create routes', () => {
    Object.entries(Routes).forEach(([key, Route]) => {
      const component = shallow(<Route.render history={{}} some="props" />);
      Route.renderResult = component;
    });

    expect(Routes).toMatchSnapshot();
  });
});
