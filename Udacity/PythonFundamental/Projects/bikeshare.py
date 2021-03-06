import time
import pandas as pd
import numpy as np

CITY_DATA = {'chicago': 'chicago.csv',
             'new york city': 'new_york_city.csv',
             'washington': 'washington.csv'}
months = ['january', 'february', 'march', 'april', 'may', 'june']
cities = ["new york city", "chicago", "washington"]
days = ["monday", "tuesday", "wednesday", "thursday",
        "friday", "saturday", "sunday", "all"]


def user_inputs_options(options, prompt_message):
    while True:
        answer = input(prompt_message).strip().lower()

        if answer in options:
            return answer
        else:
            answer = ""
            print("Please enter the information.\n")


def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')

    # TO DO: get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    # get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    city = user_inputs_options(
        cities,
        "Please enter only: 'new york city', 'chicago' or 'washington' > ")

    # get user input for month (all, january, february, ... , june)
    month = user_inputs_options(
        months,
        "Please enter only month: 'january', 'february', 'march', 'april', 'may', 'june' or 'all' > ")

    # get user input for day of week (all, monday, tuesday, ... sunday)
    day = user_inputs_options(
        days,
        "Please enter only day: 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday' or 'all' > ")

    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    # load data file into a dataframe
    df = pd.read_csv(CITY_DATA[city])

    # convert the Start Time column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])

    # extract month and day of week from Start Time to create new columns
    df['month'] = df['Start Time'].dt.month
    df['day_of_week'] = df['Start Time'].dt.day_name()
    df["start_hour"] = df['Start Time'].dt.hour

    # filter by month if applicable
    if month != 'all':
        # use the index of the months list to get the corresponding int
        month = months.index(month)+1

        # filter by month to create the new dataframe
        df = df[df['month'] == month]

    # filter by day of week if applicable
    if day != 'all':
        # filter by day of week to create the new dataframe
        df = df[df['day_of_week'] == day.title()]

    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    # TO DO: display the most common month
    month_stat = df["month"].mode()[0] - 1
    most_common_month = months[month_stat].title()

    # TO DO: display the most common day of week
    most_common_day = df["day_of_week"].mode()[0]

    # TO DO: display the most common start hour
    most_common_hour = df["start_hour"].mode()[0]

    print('The most common month:', most_common_month)
    print("The most common day of week: ", most_common_day)
    print("The most common start hour: ", most_common_hour)

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    # TO DO: display most commonly used start station
    most_used_start_station = df['Start Station'].mode()[0]
    print("Most commonly used start station: ", most_used_start_station)

    # TO DO: display most commonly used end station
    most_used_end_station = df['End Station'].mode()[0]
    print("Most commonly used end station: ", most_used_end_station)

    # TO DO: display most frequent combination of start station and end station trip
    df["start_end"] = df['Start Station'] + ' to ' + df['End Station']
    frequent_combination = df["start_end"].mode()[0]
    print("Frequent combination of start station and end station trip: ",
          frequent_combination)

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # TO DO: display total travel time
    total_travel_time = df["Trip Duration"].sum()
    print("Total travel time: ", total_travel_time)

    # TO DO: display mean travel time
    mean_time = df["Trip Duration"].mean()
    print("The average travel time: ", mean_time)

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # TO DO: Display counts of user types
    user_types = df['User Type'].value_counts()

    print("Counts of user types:", user_types)

    # TO DO: Display counts of gender
    if "Gender" in df:
        gender_counts = df['Gender'].value_counts()
        print("Counts of gender:", gender_counts)

    # TO DO: Display earliest, most recent, and most common year of birth
    if "Birth Year" in df:
        print("\nEarliest year of birth: ", df["Birth Year"].min())
        print("Most recent year of birth: ", df["Birth Year"].max())
        print("Most common year of birth: ",
              df["Birth Year"].value_counts().idxmax())

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def raw_data(df):
    st = 0
    raw_data = input('\nFor raw data: Enter yes otherwise no.\n')
    while raw_data.lower() == 'yes':
        df_slice = df.iloc[st: st+5]
        print(df_slice)
        st += 5
        raw_data = input(
            '\nFor displaying more five raw data results please enter yes otherwise no.\n')


def main():
    while True:
        city, month, day = get_filters()
        df = load_data(city, month, day)
        # print(df)
        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
        raw_data(df)
    # yes
        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
    main()
