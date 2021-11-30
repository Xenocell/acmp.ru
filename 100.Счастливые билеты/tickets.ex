defmodule Application.LuckyTickets do

  def get_number_digits_ticket do
    number_digits_ticket = IO.gets("Количество цифр в билете: ")
      |> String.trim()
      |> Integer.parse(10)
    if number_digits_ticket == :error,
      do: get_number_digits_ticket(),
      else: if rem(elem(number_digits_ticket, 0), 2) != 0, do: get_number_digits_ticket(), else: number_digits_ticket |> elem(0)
  end

  def get_last_number(number_digits_ticket, last_number \\ 9) do
    if number_digits_ticket > 0, do: get_last_number(number_digits_ticket-1, (last_number*10)+9), else: last_number
  end

  def split_number(number, number_digits) do
    {div(number, Integer.pow(10, number_digits)), rem(number, Integer.pow(10, number_digits))}
  end

  def get_lucky_ticket_count(number \\ 0, last_number, number_digits_ticket, count \\ 0) do
    if number <= last_number do
      {heat_number, tail_number} = split_number(number, round(number_digits_ticket/2))

      if Integer.digits(heat_number) |> Enum.sum() == Integer.digits(tail_number) |> Enum.sum() do
        get_lucky_ticket_count(number+1, last_number, number_digits_ticket, count+1)
      else
        get_lucky_ticket_count(number+1, last_number, number_digits_ticket, count)
      end
    else
      count
    end
  end

  def main do
    number_digits_ticket = get_number_digits_ticket()
    get_last_number(number_digits_ticket-1)
      |> get_lucky_ticket_count(number_digits_ticket)
      |> IO.puts()
  end
end
