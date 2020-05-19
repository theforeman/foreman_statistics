export function trendTypeSelected({ value }) {
  ['trend_trendable_id', 'trend_name'].forEach(id => {
    const element = document.getElementById(id);
    element.disabled = value !== 'FactName';
    element.value = '';
  });
}
