import React from 'react';
import PropTypes from 'prop-types';
import { withRenderHandler } from 'foremanReact/common/HOC';
import { translate as __ } from 'foremanReact/common/I18n';
import { EmptyStatePattern } from 'foremanReact/components/common/EmptyState';
import StatisticsChartsList from '../../../Components/StatisticsChartsList';

const Statistics = ({ statisticsMeta }) => {
  if (!statisticsMeta) {
    return (
      <EmptyStatePattern
        icon="info"
        header={__('No Charts To Load')}
        description=""
      />
    );
  }
  return <StatisticsChartsList data={statisticsMeta} />;
};

Statistics.propTypes = {
  statisticsMeta: PropTypes.array.isRequired,
};

export default withRenderHandler({
  Component: Statistics,
});
