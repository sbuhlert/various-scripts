#!/usr/bin/perl -w
#=============================================================================
#
#  Copyright 2010  Etienne URBAH
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details at
#  http://www.gnu.org/licenses/gpl.html
#
#  For usage and SPECIAL WARNING, see the 'Help' section below.
#
#=============================================================================
use 5.008_000;    #  For correct Unicode support
use warnings;
use strict;
use Encode;

$| = 1;           #  Autoflush STDOUT

#-----------------------------------------------------------------------------
#  Function ucRemoveEolUnderscoreDash :
#  Set Uppercase, remove End of line, Underscores and Dashes
#-----------------------------------------------------------------------------
sub ucRemoveEolUnderscoreDash
{
  local $_ = uc($_[0]);
  chomp;
  tr/_\-//d;
  $_;
}

#-----------------------------------------------------------------------------
#  Constants
#-----------------------------------------------------------------------------
my $Encoding_Western  = 'ISO-8859-1';
my $Encoding_Central  = 'ISO-8859-2';
my $Encoding_Baltic   = 'ISO-8859-4';
my $Encoding_Turkish  = 'ISO-8859-9';
my $Encoding_W_Euro   = 'ISO-8859-15';
my $Code_Page_OldWest =   850;
my $Code_Page_Central =  1250;
my $Code_Page_Western =  1252;
my $Code_Page_Turkish =  1254;
my $Code_Page_Baltic  =  1257;
my $Code_Page_UTF8    = 65001;

my $HighBitSetChars   = pack('C*', 0x80..0xFF);

my %SuperEncodings    =
  ( &ucRemoveEolUnderscoreDash($Encoding_Western), 'cp'.$Code_Page_Western,
    &ucRemoveEolUnderscoreDash($Encoding_Central), 'cp'.$Code_Page_Central,
    &ucRemoveEolUnderscoreDash($Encoding_Baltic),  'cp'.$Code_Page_Baltic,
    &ucRemoveEolUnderscoreDash($Encoding_Turkish), 'cp'.$Code_Page_Turkish,
    &ucRemoveEolUnderscoreDash($Encoding_W_Euro),  'cp'.$Code_Page_Western,
    &ucRemoveEolUnderscoreDash('cp'.$Code_Page_OldWest),
                                                   'cp'.$Code_Page_Western );

my %EncodingNames     = ( 'cp'.$Code_Page_Central, 'Central European',
                          'cp'.$Code_Page_Western, 'Western European',
                          'cp'.$Code_Page_Turkish, '    Turkish     ',
                          'cp'.$Code_Page_Baltic,  '     Baltic     ' );

my %NonAccenChars     = ( 
                          #--------------------------------#
'cp'.$Code_Page_Central,  #   Central European (cp1250)    #
                          #--------------------------------#
                          #€_‚_„…†‡_‰Š‹ŚŤŽŹ_‘’“”•–—_™š›śťžź#
                          'E_,_,.++_%S_STZZ_````.--_Ts_stzz'.

                          # ˇ˘Ł¤Ą¦§¨©Ş«¬­®Ż°±˛ł´µ¶·¸ąş»Ľ˝ľż#
                          '_``LoAlS`CS_--RZ`+,l`uP.,as_L~lz'.

                          #ŔÁÂĂÄĹĆÇČÉĘËĚÍÎĎĐŃŇÓÔŐÖ×ŘŮÚŰÜÝŢß#
                          'RAAAALCCCEEEEIIDDNNOOOOxRUUUUYTS'.

                          #ŕáâăäĺćçčéęëěíîďđńňóôőö÷řůúűüýţ˙#
                          'raaaalccceeeeiiddnnoooo%ruuuuyt`',

                          #--------------------------------#
'cp'.$Code_Page_Western,  #   Western European  (cp1252)   #
                          #--------------------------------#
                          #€_‚ƒ„…†‡ˆ‰Š‹Œ_Ž__‘’“”•–—˜™š›œ_žŸ#
                          'E_,f,.++^%S_O_Z__````.--~Ts_o_zY'.

                          # ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿#
                          '_!cLoYlS`Ca_--R-`+23`uP.,10_qh3_'.

                          #ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞß#
                          'AAAAAAACEEEEIIIIDNOOOOOxOUUUUYTS'.

                          #àáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ#
                          'aaaaaaaceeeeiiiidnooooo%ouuuuyty',

                          #--------------------------------#
'cp'.$Code_Page_Turkish,  #       Turkish  (cp1254)        #
                          #--------------------------------#
                          #€_‚ƒ„…†‡ˆ‰Š‹Œ____‘’“”•–—˜™š›œ__Ÿ#
                          'E_,f,.++^%S_O____````.--~Ts_o__Y'.

                          # ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿#
                          '_!cLoYlS`Ca_--R-`+23`uP.,10_qh3_'.

                          #ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞß#
                          'AAAAAAACEEEEIIIIGNOOOOOxOUUUUISS'.

                          #àáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ#
                          'aaaaaaaceeeeiiiignooooo%ouuuuisy',

                          #--------------------------------#
'cp'.$Code_Page_Baltic,   #       Baltic   (cp1257)        #
                          #--------------------------------#
                          #€_‚_„…†‡_‰_‹_¨ˇ¸_‘’“”•–—_™_›_¯˛_#
                          'E_,_,.++_%___``,_````.--_T___-,_'.

                          # �¢£¤�¦§Ø©Ŗ«¬­®Æ°±²³´µ¶·ø¹ŗ»¼½¾æ#
                          '__cLo_lSOCR_--RA`+23`uP.o1r_qh3a'.

                          #ĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽß#
                          'AIACAAEECEZEGKILSNNOOOOxULSUUZZS'.

                          #ąįāćäåęēčéźėģķīļšńņóōõö÷ųłśūüżž˙#
                          'aiacaaeecezegkilsnnoooo%ulsuuzz`' );

my %AccentedChars;
my $AccentedChars     = '';
my $NonAccenChars     = '';
for ( $Code_Page_Central, $Code_Page_Western,
      $Code_Page_Turkish, $Code_Page_Baltic )
    {
      $AccentedChars{'cp'.$_}  = decode('cp'.$_, $HighBitSetChars);
      $AccentedChars          .= $AccentedChars{'cp'.$_};
      $NonAccenChars          .= $NonAccenChars{'cp'.$_};
    }
#print "\n", length($NonAccenChars), '  ', $NonAccenChars,"\n";
#print "\n", length($AccentedChars), '  ', $AccentedChars,"\n";

my $QuotedMetaNonAccenChars = quotemeta($NonAccenChars);

my $DiacriticalChars  = '';
for  ( 0x0300..0x036F, 0x1DC0..0x1DFF )
     { $DiacriticalChars .= chr($_) }

#-----------------------------------------------------------------------------
#  Parse options and parameters
#-----------------------------------------------------------------------------
my $b_Help        = 0;
my $b_Interactive = 1;
my $b_UTF8        = 0;
my $b_Parameter   = 0;
my $Folder;

for  ( @ARGV )
{
  if    ( lc($_) eq '--' )
        { $b_Parameter = 1 }
  elsif ( (not $b_Parameter) and (lc($_) eq '--batch') )
        { $b_Interactive = 0 }
  elsif ( (not $b_Parameter) and (lc($_) eq '--utf8') )
        { $b_UTF8 = 1 }
  elsif ( $b_Parameter or (substr($_, 0, 1) ne '-') )
        {
          if  ( defined($Folder) )
              { die "$0 accepts only 1 parameter\n" }
          else
              { $Folder = $_ }
        }
  else
        { $b_Help = 1 }
}

#-----------------------------------------------------------------------------
#  Help
#-----------------------------------------------------------------------------
if  ( $b_Help )
    {
      die << "END_OF_HELP"

$0  [--help]  [--batch]  [--]  [folder]

This script renames files with accented and diacritical Latin characters :

-  This PERL script starts from the folder given in parameter, or else from
   the current folder.
-  It recursively searches for files with characters belonging to 80 - FF of
   CP 1250, CP 1252, CP 1254 and CP 1257 (mostly accented Latin characters)
   or Latin characters having diacritical marks.
-  It calculates new file names by removing the accents and diacritical marks
   only from Latin characters  (For example,  Été --> Ete).
-  It displays all proposed renaming and perhaps conflicts, and asks the user
   for global approval.
-  If the user has approved, it renames all files having no conflict.

Option '--batch' avoids interactive questions.  Use with care.

Option '--'      avoids the next parameter to be interpreted as option.

SPECIAL WARNING :
-  This script was originally encoded in UTF-8, and should stay so.
-  This script may rename a lot of files.
-  Files names are theoretically all encoded only with UTF-8.  But some file
   names may be found to contain also some characters having legacy encoding.
-  The author has applied efforts for consistency checks, robustness, conflict
   detection and use of appropriate encoding.
   So this script should only rename files by removing accents and diacritical
   marks from Latin characters.
-  But this script has been tested only under a limited number of OS
   (Windows, Mac OS X, Linux) and a limited number of terminal encodings
   (CP 850, ISO-8859-1, UTF-8).
-  So, under weird circumstances, this script could rename many files with
   random names.
-  Therefore, this script should be used with care, and modified with extreme
   care (beware encoding of internal strings, inputs, outputs and commands)
END_OF_HELP
    }

#-----------------------------------------------------------------------------
#  If requested, change current folder
#-----------------------------------------------------------------------------
if  ( defined($Folder) )
    { chdir($Folder)  or  die  "Can NOT set '$Folder' as current folder\n" }

#-----------------------------------------------------------------------------
#  Following instruction is MANDATORY.
#  The return value should be non-zero, but on some systems it is zero.
#-----------------------------------------------------------------------------
utf8::decode($AccentedChars);
#  or  die "$0: '\$AccentedChars' should be UTF-8 but is NOT.\n";

#-----------------------------------------------------------------------------
#  Check consistency on 'tr'
#-----------------------------------------------------------------------------
$_ = $AccentedChars;
eval "tr/$AccentedChars/$QuotedMetaNonAccenChars/";
if  ( $@ )  { warn $@ }
if  ( $@ or ($_ ne $NonAccenChars) )
    { die "$0: Consistency check on 'tr' FAILED :\n\n",
          "Translated Accented Chars :  ", length($_), ' :  ', $_, "\n\n",
          "       Non Accented Chars :  ", length($NonAccenChars), ' :  ',
          $NonAccenChars, "\n" }

#-----------------------------------------------------------------------------
#  Constants depending on the OS
#-----------------------------------------------------------------------------
my $b_Windows = ( defined($ENV{'OS'}) and ($ENV{'OS'} eq 'Windows_NT') );

my ($Q, $sep, $sep2, $HOME, $Find, @List, $cwd, @Move);

if  ( $b_Windows )
    {
      $Q    = '"';
      $sep  = '\\';
      $sep2 = '\\\\';
      $HOME = $ENV{'USERPROFILE'};
      $Find = 'dir /b /s';
      @List = ( ( (`ver 2>&1` =~ m/version\s+([0-9]+)/i) and ($1 >= 6) ) ?
                ('icacls') :
                ( 'cacls') );
      $cwd  = `cd`;  chomp $cwd;  $cwd = quotemeta($cwd);
      @Move = ('move');
    }
else
    {
      $Q    = "'";
      $sep  = '/';
      $sep2 = '/';
      $HOME = $ENV{'HOME'};
      $Find = 'find .';
      @List = ('ls', '-d', '--');
      @Move = ('mv', '--');
      if  ( -w '/bin' )  { die "$0: For safety reasons, ",
                               "usage is BLOCKED to administrators.\n"}
    }

my $Encoding;
my $ucEncoding;
my $InputPipe = '-|';                                # Used as global variable

#-----------------------------------------------------------------------------
#  Under Windows, associate input and output encodings to code pages :
#  -  Get the original code page,
#  -  If it is not UTF-8, try to set it to UTF-8,
#  -  Define the input encoding as the one associated to the ACTIVE code page,
#  -  If STDOUT is the console, encode output for the ORIGINAL code page.
#-----------------------------------------------------------------------------
my $Code_Page_Original;
my $Code_Page_Active;

if  ( $b_Windows )
    {
      #-----------------------------------------------------------------------
      #  Get the original code page
      #-----------------------------------------------------------------------
      $_ = `chcp`;
      m/([0-9]+)$/  or  die "Non numeric Windows code page :  ", $_;
      $Code_Page_Original = $1;
      print 'Windows Original Code Page = ', $Code_Page_Original,
            ( $Code_Page_Original == $Code_Page_UTF8 ?
              ' = UTF-8, display is perhaps correct with a true type font.' :
              '' ), "\n\n";
      $Code_Page_Active = $Code_Page_Original ;

      #-----------------------------------------------------------------------
      #  The input encoding must be the same as the ACTIVE code page
      #-----------------------------------------------------------------------
      $Encoding = ( $Code_Page_Active == $Code_Page_UTF8 ?
                    'utf8' :
                    'cp'.$Code_Page_Active ) ;
      $InputPipe .= ":encoding($Encoding)";
      print "InputPipe = '$InputPipe'\n\n";

      #-----------------------------------------------------------------------
      #  If STDOUT is the console, output encoding must be the same as the
      #  ORIGINAL code page
      #-----------------------------------------------------------------------
      if  ( $Code_Page_Original != $Code_Page_UTF8 )
          {
            no  warnings  'unopened';
            @_ = stat(STDOUT);
            use warnings;
            if  ( scalar(@_) and ($_[0] == 1) )
                { binmode(STDOUT, ":encoding(cp$Code_Page_Original)") }
            else
                { binmode(STDOUT, ":encoding($Encoding)") }
          }
    }

#-----------------------------------------------------------------------------
#  Under *nix, if the 'LANG' environment variable contains an encoding,
#  verify that this encoding is supported by the OS and by PERL.
#-----------------------------------------------------------------------------
elsif ( defined($ENV{'LANG'}) and ($ENV{'LANG'} =~ m/\.([^\@]+)$/i) )
      {
        $Encoding = $1;

        my $Kernel = `uname -s`;
        chomp $Kernel;
        my $ucEncoding = &ucRemoveEolUnderscoreDash($Encoding);
        if  ( (lc($Kernel) ne 'darwin') and not grep {$_ eq $ucEncoding}
                       ( map { ($_, &ucRemoveEolUnderscoreDash($_)) }
                         `locale -m` ) )
            { die "Encoding = '$Encoding' or '$ucEncoding'  NOT supported ".
                  "by the OS\n" }

        my $ucLocale = &ucRemoveEolUnderscoreDash($ENV{'LANG'});
        if  ( not grep {$_ eq $ucLocale}
                       ( map { ($_, &ucRemoveEolUnderscoreDash($_)) }
                         `locale -a` ) )
            { die "Locale = '$ENV{LANG}' or '$ucLocale'  NOT supported ".
                  "by the OS\n" }

        if  ( not defined(Encode::find_encoding($Encoding)) )
            { die "Encoding = '$Encoding' or '$ucEncoding'  NOT supported ".
                  "by PERL\n" }

        print "Encoding = '$Encoding'  is supported by the OS and PERL\n\n";
        binmode(STDOUT, ":encoding($Encoding)");
      }

#-----------------------------------------------------------------------------
#  Check consistency between parameter of 'echo' and output of 'echo'
#-----------------------------------------------------------------------------
undef $_;
if  ( defined($Encoding)  )
    {
      $ucEncoding = &ucRemoveEolUnderscoreDash($Encoding);
      if    ( defined($SuperEncodings{$ucEncoding}) )
            { $_ = substr($AccentedChars{$SuperEncodings{$ucEncoding}},
                          0x20, 0x60) }
      elsif ( defined($AccentedChars{$Encoding}) )
            { $_ = $AccentedChars{$Encoding} }
      elsif ( $Encoding =~ m/^utf-?8$/i )
            { $_ = $AccentedChars }
    }
if  ( not defined($_) )                # Chosen chars are same in 4 code pages
    { $_ = decode('cp'.$Code_Page_Central,
                  pack('C*', 0xC9, 0xD3, 0xD7, 0xDC,                    # ÉÓ×Ü
                             0xE9, 0xF3, 0xF7, 0xFC)) }                 # éó÷ü
#print  $_, "  (Parameter)\n\n";
#system 'echo', $_;
utf8::decode($_);
#print  "\n", $_, "  (Parameter after utf8::decode)\n\n";
my @EchoCommand = ( $b_Windows ?
                    "echo $_" :
                    ('echo', $_) );
#system @EchoCommand;

open(ECHO, $InputPipe, @EchoCommand)  or  die 'echo $_: ', $!;
my $Output = join('', <ECHO>);
close(ECHO);
chomp $Output;
#print "\n", $Output, "  (Output of 'echo')\n";
utf8::decode($Output);
#print "\n", $Output, "  (Output of 'echo' after utf8::decode)\n\n";

if  ( $Output ne $_ )
    {
      warn "$0: Consistency check between parameter ",
                         "of 'echo' and output of 'echo' FAILED :\n\n",
           "Parameter of 'echo' :  ", length($_), ' :  ', $_, "\n\n",
           "   Output of 'echo' :  ", length($Output), ' :  ', $Output, "\n";
      exit 1;
    }

#-----------------------------------------------------------------------------
#  Print the translation table
#-----------------------------------------------------------------------------
if  ( defined($Encoding) )
{
  undef $_;
  $ucEncoding = &ucRemoveEolUnderscoreDash($Encoding);
  if    ( defined($SuperEncodings{$ucEncoding}) )
        {
          $_ = $SuperEncodings{$ucEncoding};
          print "--------- $EncodingNames{$_} ---------\n",
                '    ', substr($AccentedChars{$_}, 0x20, 0x20), "\n",
                '--> ', substr($NonAccenChars{$_}, 0x20, 0x20), "\n\n",
                '    ', substr($AccentedChars{$_}, 0x40, 0x20), "\n",
                '--> ', substr($NonAccenChars{$_}, 0x40, 0x20), "\n\n",
                '    ', substr($AccentedChars{$_}, 0x60, 0x20), "\n",
                '--> ', substr($NonAccenChars{$_}, 0x60, 0x20), "\n\n" }
  else
  {
    for ( 'cp'.$Code_Page_Central, 'cp'.$Code_Page_Western,
          'cp'.$Code_Page_Turkish, 'cp'.$Code_Page_Baltic )
    {
      if  ( ('cp'.$Encoding eq $_) or ($Encoding =~ m/^utf-?8$/i) )
          { print "--------- $EncodingNames{$_} ---------\n",
                  '    ', substr($AccentedChars{$_},    0, 0x20), "\n",
                  '--> ', substr($NonAccenChars{$_},    0, 0x20), "\n\n",
                  '    ', substr($AccentedChars{$_}, 0x20, 0x20), "\n",
                  '--> ', substr($NonAccenChars{$_}, 0x20, 0x20), "\n\n",
                  '    ', substr($AccentedChars{$_}, 0x40, 0x20), "\n",
                  '--> ', substr($NonAccenChars{$_}, 0x40, 0x20), "\n\n",
                  '    ', substr($AccentedChars{$_}, 0x60, 0x20), "\n",
                  '--> ', substr($NonAccenChars{$_}, 0x60, 0x20), "\n\n" }
    }
  }
}

#-----------------------------------------------------------------------------
#  Completely optional :
#  Inside the Unison file, find the accented file names to ignore
#-----------------------------------------------------------------------------
my $UnisonFile = $HOME.$sep.'.unison'.$sep.'common.unison';
my @Ignores;

if  ( open(UnisonFile, '<', $UnisonFile) )
    {
      print "\nUnison File '", $UnisonFile, "'\n";
      while  ( <UnisonFile> )
      {
        if  ( m/^\s*ignore\s*=\s*Name\s*(.+)/ )
            {
              $_ = $1 ;
              if  ( m/[$AccentedChars]/ )
                  { push(@Ignores, $_) }
            }
      }
      close(UnisonFile);
    }
print map("  Ignore: ".$_."\n", @Ignores);

#-----------------------------------------------------------------------------
#  Function OutputAndErrorFromCommand :
#
#  Execute the command given as array in parameter, and return STDOUT + STDERR
#
#  Reads global variable $InputPipe
#-----------------------------------------------------------------------------
sub OutputAndErrorFromCommand
{
  local $_;
  my @Command = @_;             # Protects content of @_ from any modification
  #---------------------------------------------------------------------------
  #  Under Windows, fork fails, so :
  #  -  Enclose into double quotes parameters containing blanks or simple
  #     quotes,
  #  -  Use piped open with redirection of STDERR.
  #---------------------------------------------------------------------------
  if  ( defined($ENV{'OS'}) and ($ENV{'OS'} eq 'Windows_NT') )
      {
        for  ( @Command )
             { s/^((-|.*(\s|')).*)$/$Q$1$Q/ }
        my $Command = join('  ', @Command);
        #print "\n", $Command;
        open(COMMAND, $InputPipe, "$Command  2>&1")  or  die '$Command: ', $!;
      }
  #---------------------------------------------------------------------------
  #  Under Unix, quoting is too difficult, but fork succeeds
  #---------------------------------------------------------------------------
  else
      {
        my $pid = open(COMMAND, $InputPipe);
        defined($pid) or die "Can't fork: $!";
        if  ( $pid == 0 )                           #  Child process
            {
              open STDERR, '>&=STDOUT';
              exec @Command;                        #  Returns only on failure
              die "Can't @Command";
            }
      }
  $_ = join('', <COMMAND>);                         #  Child's STDOUT + STDERR
  close COMMAND;
  chomp;
  utf8::decode($_);
  $_;
}

#-----------------------------------------------------------------------------
#  Find recursively all files inside the current folder.
#  Verify accessibility of files with accented names.
#  Calculate non-accented file names from accented file names.
#  Build the list of duplicates.
#-----------------------------------------------------------------------------
my %Olds;                                # $Olds{$New} = [ $Old1, $Old2, ... ]
my $Old;
my $Dir;
my $Command;
my $ErrorMessage;
my $New;
my %News;

print "\n\nFiles with accented name and the corresponding non-accented name ",
      ":\n";

open(FIND, $InputPipe, $Find)  or  die $Find, ': ', $!;

FILE:
while  ( <FIND> )
{
  chomp;
  #---------------------------------------------------------------------------
  #  If the file path contains UTF-8, following instruction is MANDATORY.
  #  If the file path does NOT contain UTF-8, it should NOT hurt.
  #---------------------------------------------------------------------------
  utf8::decode($_);

  if  ( $b_Windows )
      { s/^$cwd$sep2// }
  else
      { s/^\.$sep2// }

  #---------------------------------------------------------------------------
  #  From now on :  $_ = Dir/OldFilename
  #---------------------------------------------------------------------------
  push(@{$Olds{$_}}, $_);

  if  ( m/([^$sep2]+)$/ and
        ($1 =~ m/[$AccentedChars]|([\ -\~][$DiacriticalChars])/) )
      {
        if  ( $b_Windows and m/$Q/ )
            {
              print "\n    $Q$_$Q\n***  contains quotes.\n";
              next;
            }
        for  my $Ignore  ( @Ignores )
        {
          if  ( m/$Ignore$/ )
              { next FILE }
        }
        $Old = $_ ;
        m/^(.*$sep2)?([^$sep2]+)$/;
        $Dir = ( defined($1) ? $1 : '');
        $_   = $2;

        #---------------------------------------------------------------------
        #  From now on :  $Old = Dir/OldFilename
        #                 $_   = OldFilename
        #---------------------------------------------------------------------
        print "\n    $Q$Old$Q\n";
        $ErrorMessage = &OutputAndErrorFromCommand(@List, $Old);
        if  ( $? != 0 )
            { print "*** $ErrorMessage\n" }
        else
            {
              #---------------------------------------------------------------
              #  Change accented Latin chars to non-accented chars.
              #  Remove all diacritical marks after Latin chars.
              #---------------------------------------------------------------
              eval "tr/$AccentedChars/$QuotedMetaNonAccenChars/";
              s/([\ -\~])[$DiacriticalChars]+/$1/g;
              #---------------------------------------------------------------
              #  From now on :  $Old = Dir/OldFilename
              #                 $_   = NewFilename
              #---------------------------------------------------------------
              if  ( $@ )
                  { warn $@ }
              else
                  {
                    $New = $Dir.$_;
                    if  ( $b_Windows or (not utf8::is_utf8($Dir)) )    # Weird
                        { utf8::decode($New) }                 # but necessary
                    $News{$Old} = $New;
                    push(@{$Olds{$New}}, $Old);
                  }
              print "--> $Q$Dir$_$Q\n";
            }
      }
}

close(FIND);

#-----------------------------------------------------------------------------
#  Print list of duplicate non-accented file names
#-----------------------------------------------------------------------------
my $b_NoDuplicate = 1;

for  my $New  ( sort keys %Olds )
{
  if  ( scalar(@{$Olds{$New}}) > 1 )
      {
        if  ( $b_NoDuplicate )
            {
              print "\n\nFollowing files would have same non-accented name ",
                    ":\n";
              $b_NoDuplicate = 0;
            }
        print "\n", map('    '.$_."\n", @{$Olds{$New}}), '--> ', $New, "\n";
        for  ( @{$Olds{$New}} )
             { delete $News{$_} };
      }
}

#-----------------------------------------------------------------------------
#  If there are NO file to rename, then exit
#-----------------------------------------------------------------------------
my $Number = scalar(keys %News);

print "\n\n";
if  ( $Number < 1 )
    {
      print "There are NO file to rename\n";
      exit;
    }

#-----------------------------------------------------------------------------
#  Ask the user for global approval of renaming
#-----------------------------------------------------------------------------
if  ( $b_Interactive )
    {
      print "In order to really rename the ", $Number,
            " files which can safely be renamed, type 'rename' :  ";
      $_ = <STDIN>;
      sleep 1;                       # Gives time to PERL to handle interrupts
      if  ( not m/^rename$/i )
          { exit 1 }
    }
else
    { print $Number, " files will be renamed\n\n" }

#-----------------------------------------------------------------------------
#  Rename accented file names sorted descending by name size
#-----------------------------------------------------------------------------
$Number  = 0;
my $Move = join('  ', @Move);

for  ( sort {length($b) <=> length($a)} keys %News )
{
  $ErrorMessage = &OutputAndErrorFromCommand(@Move, $_, $News{$_});
  if  ( $? == 0 )
      { $Number++ }
  else
      { print "\n$Move  $Q$_$Q\n", (' ' x length($Move)),
        "  $Q$News{$_}$Q\n", ('*' x length($Move)), "  $ErrorMessage\n" }
}
print "\n$Number files have been successfully renamed\n";

__END__
