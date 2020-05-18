import React, { useEffect } from 'react';

export const callOnMount = callback => WrappedComponent => componentProps => {
  // fires callback onMount, [] means don't listen to any props change
  useEffect(() => {
    callback(componentProps);
  }, [componentProps]);

  return <WrappedComponent {...componentProps} />;
};

export const withRenderHandler = ({
  Component,
  LoadingComponent = () => jest.fn(),
  ErrorComponent = () => jest.fn(),
  EmptyComponent = () => jest.fn(),
}) => componentProps => {
  const { isLoading, hasData, hasError } = componentProps;

  if (isLoading && !hasData) return <LoadingComponent {...componentProps} />;
  if (hasError) return <ErrorComponent {...componentProps} />;
  if (hasData) return <Component {...componentProps} />;
  return <EmptyComponent {...componentProps} />;
};
