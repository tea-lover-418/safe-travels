export const compact = <T>(arr: (T | undefined)[]): T[] => {
  return arr.filter(Boolean) as T[];
};
