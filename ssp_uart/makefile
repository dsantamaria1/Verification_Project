#/simv +test=4 -cm_dir name
#urg -dbname merge/sspUart -dir tfifoClear.vdb/ rfifoClear.vdb/
FLAGS=-debug_all -sverilog -ntb -F
FLAGS2=-debug_all -sverilog -R -gui -Mupdate -F
MEM_FLAGS=+memcbk +v2k
DATE=`date +'%H''%M''%S'`

build:
	vcs $(FLAGS) filelist $(MEM_FLAGS)

buildInt:
	vcs $(FLAGS2) filelist&

run:	build
	./simv +test=$(test) +ntb_random_seed=$(DATE) -cm_dir test$(test)_$(DATE) && mv *vdb coverage/

clean:
	rm -rf simv* DVEfiles csrc ucli.key *vcd *vpd opendatabase.log
