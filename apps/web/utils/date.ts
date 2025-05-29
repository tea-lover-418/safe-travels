import dayjs from "dayjs";

export const formatDefault = (date: string, endDate?: string) => {
  return `${dayjs(date).format("DD MMM YYYY")} ${endDate ? "- " + dayjs(endDate).format("DD MMM YYYY") : ""}`;
};
