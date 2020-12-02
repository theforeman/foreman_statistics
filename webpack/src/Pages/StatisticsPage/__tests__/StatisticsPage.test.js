import { testComponentSnapshotsWithFixtures } from '@theforeman/test';
import { statisticsProps } from '../StatisticsPage.fixtures';
import StatisticsPage from '../StatisticsPage';

const fixtures = {
  'render with props': statisticsProps,
};

describe('StatisticsPage', () => {
  describe('rendering', () =>
    testComponentSnapshotsWithFixtures(StatisticsPage, fixtures));
});
