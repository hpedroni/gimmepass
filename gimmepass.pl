#!/usr/bin/env perl

use strict;
use feature qw ( say );
use List::Util qw(shuffle);

my ($password_size) = @ARGV;

$password_size = 25 unless $password_size;

# discount the special chars (we use 4) 
my $words_size = $password_size - 4;
my $max_word_size = int($words_size / 3);
   $max_word_size = 4 if $max_word_size <= 3;

my @chars     = qw ( @ # % _ );
my @numbers   = qw ( 0 1 2 3 4 5 6 7 8 9 );
my $word_list = {};
my (@password, @char_num, $char, $num, $words);

# read word list
my @dictionaries = qw (br-sem-acentos.txt english_words.txt);

for my $dict_file (@dictionaries) {
    open FH, $dict_file;
    while (<FH>) { chomp; 
        tr/A-Z/a-z/;           # lowercase any capital word in the dict 
        my $size = length($_); # size of the word 
        next if $size <=3;     # we don't want short words in the password
        $word_list->{$_}++ if length($_) <= $max_word_size; 
    }
    close FH;
}
my @word_list = keys %$word_list;

# randomize chars and numbers
while (@char_num < 3){
    my $char_idx = int(rand(@chars));  $char = $chars[$char_idx];  undef $chars[$char_idx];
    my $num_idx  = int(rand(@numbers)); $num = $numbers[$num_idx]; undef $numbers[$num_idx];
    push @char_num, $char if $char;
    push @char_num, $num if $num;
}
push @password, join "", @char_num; # char num password block

# randomize words
while (length $words < $words_size ) {
    $words .= ucfirst($word_list[int(rand(@word_list))]);
}
push @password, $words; # words password block

# randomize the words and chars block so they are either at the end or begining
@password = shuffle @password;
my $password = join "", @password; 
say "Final password size: " . length $password; 
say $password
