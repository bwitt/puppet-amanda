# frozen_string_literal: true

require 'spec_helper'

describe 'amanda::client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.not_to contain_class('xinetd') }

      if os_facts['os']['family'] == 'RedHat'
        it { is_expected.to contain_service('amanda.socket').with_ensure('running').with_enable(true) }
        it { is_expected.not_to contain_service('amanda-udp.socket') }
      else
        it { is_expected.not_to contain_service('amanda.socket') }
      end

      context 'with xinetd => true' do
        let(:params) { { xinetd: true } }

        it { is_expected.to compile.with_all_deps }

        if os_facts['os']['family'] == 'Debian'
          %w[amanda_tcp amanda_udp].each do |service|
            it { is_expected.to contain_xinetd__service(service) }
          end
        else
          it { is_expected.not_to contain_class('xinetd') }
          it { is_expected.to contain_service('amanda.socket') }
        end
      end
    end
  end
end
