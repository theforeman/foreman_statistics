export const selectStatisticsPage = state =>
  state.foremanStatistics.statisticsPage;

export const selectStatisticsMetadata = state =>
  selectStatisticsPage(state).metadata;
export const selectStatisticsIsLoading = state =>
  selectStatisticsPage(state).isLoading;
export const selectStatisticsMessage = state =>
  selectStatisticsPage(state).message;
export const selectStatisticsHasError = state =>
  selectStatisticsPage(state).hasError;
export const selectStatisticsHasMetadata = state =>
  selectStatisticsPage(state).hasData;
