defmodule Application.Structs.Train do
  defstruct [:name, :time_departure, :time_arrival, :speed]

  alias __MODULE__

  def new(text) do
    parse_text = Regex.run(~r/([a-zA-Z0-9- ']+) ([0-9][0-9]:[0-9][0-9]) ([0-9][0-9]:[0-9][0-9])/, text)
    time_departure = Time.from_iso8601(Enum.at(parse_text, 2) <> ":00")
    time_arrival = Time.from_iso8601(Enum.at(parse_text, 3) <> ":00")
    %Train{
        name: Enum.at(parse_text, 1),
        time_departure: elem(time_departure, 1),
        time_arrival: elem(time_arrival, 1)
    }
  end

  def calc_speed(train, distance) do
    diff_time = if Time.compare(train.time_arrival, train.time_departure) == :gt,
                    do: (Time.diff(train.time_arrival, train.time_departure)/60)/60,
                    else:
                        if Time.compare(train.time_arrival, train.time_departure) == :lt,
                            do: (24*60 + (train.time_arrival.hour*60 + train.time_arrival.minute) - (train.time_departure.hour*60 + train.time_departure.minute))/60,
                            else: 0
    %{train | speed: (if diff_time == 0, do: 0, else: round((distance)/diff_time))}
  end
end

defmodule Application.Train do
  alias Application.Structs.Train

  def main do
    distance = 650
    initial_list = [
        [
            "'ER-200' 06:43 10:40",
            "'Red Arrow' 23:55 07:55",
            "'Express' 23:59 08:00"
        ],
        [
            "'Train1' 00:00 00:00",
            "'Train2' 00:00 00:01",
            "'Train3' 00:01 00:01"
        ],
        [
            "'Slow Train 1' 10:00 09:59",
            "'Slow Train 2' 10:00 10:00"
        ]
    ]

    Enum.each(initial_list, fn(list) ->
        fastest_train = Enum.map(list, fn(x) ->
            Train.new(x)
                |> Train.calc_speed(distance)
        end) |> Enum.max_by( fn (l) -> l.speed end)
        IO.puts "The fastest train is #{fastest_train.name}\nIts speed is #{fastest_train.speed} km/h, approximately.\n"
    end)
  end
end
