import React from 'react';
import { screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import { rtlHelpers } from 'foremanReact/common/rtlTestHelpers';
import { API } from 'foremanReact/redux/API';

import StatisticsChartsList from './';
import { statisticsData } from './StatisticsChartsList.fixtures';

jest.mock('foremanReact/redux/API/API');

const { renderWithStore } = rtlHelpers;

describe('StatisticsChartsList', () => {
  beforeEach(() => {
    API.get.mockImplementation(() => new Promise(() => {}));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('renders no chart panels for empty data', () => {
    renderWithStore(<StatisticsChartsList data={{}} />);

    expect(screen.queryByText('OS Distribution')).not.toBeInTheDocument();
    expect(
      screen.queryByText('Architecture Distribution')
    ).not.toBeInTheDocument();
  });

  it('renders two chart panels for fixture data', () => {
    renderWithStore(<StatisticsChartsList data={statisticsData} />);

    expect(screen.getByText('OS Distribution')).toBeInTheDocument();
    expect(
      screen.getByText('Architecture Distribution')
    ).toBeInTheDocument();
  });
});
