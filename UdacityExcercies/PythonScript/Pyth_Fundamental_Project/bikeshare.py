import time
import pandas as pd
import numpy as np

CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }
months = ['january', 'february', 'march', 'april', 'may', 'june']
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
    
    while True:        
        try:        
            city = str(input("Please enter city name(chicago, new york city, washington): "))                
        except ValueError:
            print("Sorry, Your city name is not correct. Please enter text not numeric.")
            #better try again... Return to the start of the loop
            continue
        if city not in {"chicago", "new york city", "washington"}:
            print("Sorry, your city is not in the data.")
            continue
        else:
            print("Great! City {} is found in data".format(city))
            break


    # TO DO: get user input for month (all, january, february, ... , june)
    while True:        
        try:        
            month = str(input("Please enter month(all, january, february, ... , june): "))                
        except ValueError:
            print("Sorry, month value is not correct. Please enter text not numeric.")
            #better try again... Return to the start of the loop
            continue
        if month not in {"all", "january", "february", "march", "april", "may", "june"}:
            print("Sorry, provided info is not in the data.")
            continue
        else:
            print("Great! {} is found in data".format(month))
            break

    # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
    while True:        
        try:        
            day = str(input("Please enter day of week (all, monday, tuesday, ... sunday): "))                
        except ValueError:
            print("Sorry, day value is not correct. Please enter text not numeric.")
            #better try again... Return to the start of the loop
            continue
        if day not in {"all", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"}:
            print("Sorry, provided info is not in the data.")
            continue
        else:
            print("Great! {} is found in data".format(day))
            break

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
    df['day_of_week'] = df['Start Time'].dt.weekday_name
    df["start_hour"] = df['Start Time'].dt.hour

    # filter by month if applicable
    if month != 'all':
        # use the index of the months list to get the corresponding int        
        month = months.index(month)+1
    
        # filter by month to create the new dataframe
        df = df[df['month']==month]

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

    print("Counts of user types:",user_types)

    # TO DO: Display counts of gender
    if "Gender" in df: 
        gender_counts = df['Gender'].value_counts()
        print("Counts of gender:",gender_counts)

    # TO DO: Display earliest, most recent, and most common year of birth
    if "Birth Year" in df:
        print("\nEarliest year of birth: ", df["Birth Year"].min())
        print("Most recent year of birth: ", df["Birth Year"].max())
        print("Most common year of birth: ", df["Birth Year"].value_counts().idxmax())

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def main():
    while True:        
        city, month, day = get_filters()
        df = load_data(city, month, day)
        #print(df)
        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)
    #yes
        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
	main()
