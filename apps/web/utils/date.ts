import dayjs from "dayjs";
import relativeTimePlugin from "dayjs/plugin/relativeTime";
import isTodayPlugin from "dayjs/plugin/isToday";

dayjs.extend(relativeTimePlugin);
dayjs.extend(isTodayPlugin);

export const formatDefault = (date: string) => {
  const parsedDate = dayjs(date);

  return `${parsedDate.fromNow()}`;
};

export const isToday = (date: string) => {
  const parsedDate = dayjs(date);

  return parsedDate.isToday();
};
