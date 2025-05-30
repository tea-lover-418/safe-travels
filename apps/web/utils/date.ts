import dayjs from "dayjs";

export const formatDefault = (date: string, endDate?: string) => {
  return `${dayjs(date).format("HH:mm - DD MMM YYYY")} ${endDate ? "- " + dayjs(endDate).format("HH:mm - DD MMM YYYY") : ""}`;
};
