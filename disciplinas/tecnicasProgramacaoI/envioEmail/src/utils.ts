import dayjs from "dayjs";
import "dayjs/locale/pt-br";

dayjs.locale("pt-br");

export function calcularIdade(dataNascimento: string): number {
  const nascimento = dayjs(dataNascimento, "DD/MM/YYYY");
  return dayjs().diff(nascimento, "year");
}

export function mesSeguinte(dataNascimento: string): string {
  const mes = dayjs(dataNascimento, "DD/MM/YYYY").month(); // 0–11
  return dayjs().month((mes + 1) % 12).format("MMMM");
}
