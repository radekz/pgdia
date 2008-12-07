PROJECT=pgdia

all: ${PROJECT}.sql ${PROJECT}.png

.SUFFIXES: .sql .dia .png

.dia.sql: $<
	tedia2sql -c -t postgres -o $@ $<
	perl -pi -wle 's/^(\s+constraint\s+)pk_([A-Z][a-zA-Z\d_]+)(\s+primary\s+key)/$$1.lcfirst($$2)."_pkey".$$3/e' $@
	@chmod 644 $@

.dia.png: $<
	dia $< -e $@ -t png-libart
	@chmod 644 $@

clean:
	rm -f ${PROJECT}.sql ${PROJECT}.png

dbkill: ${PROJECT}.sql
	@awk '/^create.table/{print "drop table " $$3 " cascade;"}' ${PROJECT}.sql 
