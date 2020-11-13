import API from 'foremanReact/API';

import { testActionSnapshotWithFixtures } from '@theforeman/test';
import { getStatisticsMeta } from '../StatisticsPageActions';
import { statisticsProps } from '../StatisticsPage.fixtures';

jest.mock('foremanReact/API');

const runStatisticsAction = (callback, props, serverMock) => {
  API.get.mockImplementation(serverMock);

  return callback(props);
};

const fixtures = {
  'should fetch statisticsMeta': () =>
    runStatisticsAction(getStatisticsMeta, {}, async () => ({
      data: { charts: statisticsProps.statisticsMeta },
    })),
  'should fetch statisticsMeta and fail': () =>
    runStatisticsAction(getStatisticsMeta, {}, async () => {
      throw new Error('some-error');
    }),
};

describe('StatisticsPage actions', () =>
  testActionSnapshotWithFixtures(fixtures));
