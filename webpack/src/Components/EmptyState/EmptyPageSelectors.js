const selectEmptyState = state => state.pluginTemplate.emptyState;
export const selectEmptyStateHeader = state => selectEmptyState(state).header;
