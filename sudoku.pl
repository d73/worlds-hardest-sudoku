use strict;

my $datafile = 'sudoku_data.txt';
my $gridSize = 9;
my $iterations = 0;

open(DATA, "< $datafile");
while(<DATA>) {
	chomp;
	my $dataString = $_;
	my $ret = solveGrid($dataString);
	print "Solved: $dataString\n";
	print "     -> $ret\n";
	printGrid(string2Grid($dataString));
	print "\n";
	printGrid(string2Grid($ret));
	print "\n\n\n";
}
close DATA;




sub solveGrid {
	$iterations++;
	my $s = shift;
	my @g = string2Grid($s);
	if (isSolved(@g)) {
		print "SUCCESS ($iterations loops)\n";
		return $s;
	}
	
	my ($row,$col) = getEasiestCandidate(@g);
	my @legalValues = getLegalValues($row,$col,@g);
	if (!@legalValues) {
		# print "No legal values found for position [$row,$col]\n";
	} else {
		foreach(@legalValues) {
			my $value = $_;
			# print "Attempting to solve:\n";
			# printGrid(@g);
			# print "\n";
			# print "Attempting value:$value in position [$row,$col], possible values are @legalValues\n";
			$g[$row][$col] = $value;
			my $ret = solveGrid(grid2String(@g));
			if ($ret) {
				return $ret;
			} else {
				# print "Nope, $value didn't work in position [$row,$col]\n";
				# print "Picking another value out of [@legalValues]\n" if ($value != $legalValues[-1]);
			}
		}
	}
	return 0;
}

sub getEasiestCandidate {
	my @g = @_;
	my $leastCandidates = 9;
	my $doRow;
	my $doCol;
	my @vals;
	for (0..($gridSize-1)) {
		my $row = $_;
		for (0..($gridSize-1)) {
			my $col = $_;
			if (!$g[$row][$col]) {
				@vals = getLegalValues($row, $col, @g);
				my $numValues = @vals;
				if ($numValues < $leastCandidates) {
					$doRow = $row;
					$doCol = $col;
					$leastCandidates = $numValues;
				}
			}
		}
	}
	# print "[$doRow, $doCol] has $leastCandidates values: ";
	# print getLegalValues($doRow,$doCol,@g);
	return($doRow,$doCol);
}

sub isSolved {
	my @g = @_;
	return 0 if grid2String(@g) =~ /0/;
	return 1;
}

sub grid2String {
	my @g = @_;
	my $row = 0;
	my $col = 0;
	my $ret;
	for (0..($gridSize-1)) {
		$row = $_;
		for (0..($gridSize-1)) {
			$col = $_;
			my $value = $g[$row][$col];
			$ret .= $value;
		}
	}
	return $ret;
}


sub string2Grid {
	my $data = shift;
	my @chars = split(//, $data);
	my $currentIndex = 0;
	my $row = 0;
	my $col = 0;
	my @ret;
	for (0..($gridSize-1)) {
		$row = $_;
		for (0..($gridSize-1)) {
			$col = $_;
			my $value = $chars[$currentIndex];
			$ret[$row][$col] = $value;
			$currentIndex++;
			# print "$row:$col = $value\n";
		}
	}
	return @ret;
}



# give a set of coords, return array of acceptable inputs
sub getLegalValues {
	my ($row, $col, @g) = @_;
	my @vals = (getValuesInSector(getSector($row, $col), @g), getValuesInRow($row, @g), getValuesInCol($col, @g));
	my %vals;
	foreach(@vals) {
		$vals{$_} = 1;
	}
	my @ret;
	for(1..$gridSize) {
		push (@ret, $_) if ($_ && !$vals{$_});
	}
	return @ret;
}

sub getSector {
	my ($row, $col) = @_;
	return 3 * int($row/3) + int($col/3)
}

# get all the values in a given sector
sub getValuesInSector {
	my ($sector,@g) = @_;
	my $row = 0;
	my $col = 0;
	my @ret;
	for (0..($gridSize-1)) {
		$row = $_;
		for (0..($gridSize-1)) {
			$col = $_;
			my $value = $g[$row][$col];
			push (@ret, $value) if ($value && getSector($row, $col) == $sector) ;
		}
	}
	# print "Vals in sector $sector: @ret\n";
	return @ret;
}

sub getValuesInRow {
	my ($row,@g) = @_;
	my @ret;
	for (0..($gridSize-1)) {
		my $value = $g[$row][$_];
		push(@ret, $value) if $value;
	}
	# print "Vals in row $row: @ret\n";
	return @ret;
}

sub getValuesInCol {
	my ($col,@g) = @_;
	my @ret;
	for (0..($gridSize-1)) {
		my $value = $g[$_][$col];
		push(@ret, $value) if $value;
	}
	# print "Vals in col $col: @ret\n";
	return @ret;
}

# given a grid of X numbers, print it
sub printGrid {
	my @g = @_;
	my $row = 0;
	my $col = 0;
	for (0..($gridSize-1)) {
		$row = $_;
		print "	";
		for (0..($gridSize-1)) {
			$col = $_;
			my $value = $g[$row][$col];
			$value = ' ' if !$value;
			print '|' if ($col && $col%3 == 0);
			print $value;
		}
		# print "\n";
		print "\n	---+---+---" if ($row<$gridSize-1 && $row%3 == 2);
		print "\n";
	}
}