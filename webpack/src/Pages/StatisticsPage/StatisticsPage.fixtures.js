import { noop } from 'foremanReact/common/helpers';
import { statisticsMeta } from '../../Components/StatisticsChartsList/StatisticsChartsList.fixtures';

export const statisticsProps = {
  statisticsMeta,
  isLoading: false,
  hasData: true,
  hasError: false,
  message: {},
  getStatisticsMeta: noop,
};
