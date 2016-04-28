# vcs -debug_all -sverilog -F filelist
FLAGS=-debug_all -sverilog -F
FLAGS2=-debug_all -sverilog -R -gui -Mupdate -F
MEM_FLAGS=+memcbk +v2k
DATE=`date +'%S'`

build:
	vcs $(FLAGS) filelist $(MEM_FLAGS)

buildInt:
	vcs $(FLAGS2) filelist&

run:	build
	./simv +test=$(test) +ntb_random_seed=$(DATE)

clean:
	rm -rf simv* DVEfiles csrc ucli.key *vcd *vpd opendatabase.log
