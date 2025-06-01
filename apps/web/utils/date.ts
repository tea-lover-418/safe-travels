import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";

dayjs.extend(relativeTime);

export const formatDefault = (date: string) => {
  const parsedDate = dayjs(date);

  return `${parsedDate.fromNow()}`;
};
