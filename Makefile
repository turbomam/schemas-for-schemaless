.PHONY: inference_prep clean

my_rdftab="https://github.com/ontodev/rdftab.rs/releases/download/v0.1.1/rdftab-x86_64-apple-darwin"

clean:
	rm -rf linkml-model-enrichment bacteria-archaea-traits multi_obo.db

inference_prep:
	git clone git@github.com:linkml/linkml-model-enrichment.git
	git clone git@github.com:bacteria-archaea-traits/bacteria-archaea-traits.git
	linkml-model-enrichment/linkml_model_enrichment/infer_model.py tsv2model \
		--class_name condensed_traits_NCBI \
		--schema_name organism \
		--sep ',' \
		bacteria-archaea-traits/output/condensed_traits_NCBI.csv > target/condensed_traits_NCBI.yaml
	curl -L -o rdftab ${my_rdftab}
	chmod +x rdftab
	# curl -L -o prefix.sql https://raw.githubusercontent.com/ontodev/rdftab.rs/master/test/prefix.sql
	curl -L -o pato.owl http://purl.obolibrary.org/obo/pato.owl
	curl -L -o uberon.owl https://raw.githubusercontent.com/obophenotype/uberon/master/uberon.owl
	# curl -L -o micro.owl http://purl.obolibrary.org/obo/micro.owl
	sqlite3 multi_obo.db < prefix.sql
	./rdftab multi_obo.db < pato.owl
	./rdftab multi_obo.db < uberon.owl
