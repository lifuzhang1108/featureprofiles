# Copyright 2022 Google LLC

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
openconfig_public:
	git clone https://github.com/openconfig/public.git openconfig_public

.PHONY: validate_paths
validate_paths: openconfig_public proto/feature_go_proto/feature.pb.go
	go run -v tools/validate_paths.go \
		--feature_root=$(CURDIR)/feature/ \
		--yang_roots=$(CURDIR)/openconfig_public/release/models/,$(CURDIR)/openconfig_public/third_party/ \
		--yang_skip_roots=$(CURDIR)/openconfig_public/release/models/wifi

proto/feature_go_proto/feature.pb.go: proto/feature.proto
	mkdir -p proto/feature_go_proto
	protoc --proto_path=proto --go_out=./ --go_opt=Mfeature.proto=proto/feature_go_proto feature.proto

proto/metadata_go_proto/metadata.pb.go: proto/metadata.proto
	mkdir -p proto/metadata_go_proto
	protoc --proto_path=proto --go_out=./ --go_opt=Mmetadata.proto=proto/metadata_go_proto metadata.proto
	goimports -w proto/metadata_go_proto/metadata.pb.go
