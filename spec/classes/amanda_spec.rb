# frozen_string_literal: true

require 'spec_helper'

describe 'amanda' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }

      if os_facts['os']['family'] == 'RedHat' && os_facts['os']['release']['major'] == '9'
        it { is_expected.to contain_class('epel') }

        context 'with manage_epel => false' do
          let(:params) { { manage_epel: false } }

          it { is_expected.not_to contain_class('epel') }
        end
      else
        it { is_expected.not_to contain_class('epel') }
      end
    end
  end
end
