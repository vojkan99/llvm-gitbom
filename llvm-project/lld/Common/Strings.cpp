//===- Strings.cpp -------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "lld/Common/Strings.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/LLVM.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/GlobPattern.h"
#include <algorithm>
#include <mutex>
#include <vector>

using namespace llvm;
using namespace lld;

SingleStringMatcher::SingleStringMatcher(StringRef Pattern) {
  if (Pattern.size() > 2 && Pattern.startswith("\"") &&
      Pattern.endswith("\"")) {
    ExactMatch = true;
    ExactPattern = Pattern.substr(1, Pattern.size() - 2);
  } else {
    Expected<GlobPattern> Glob = GlobPattern::create(Pattern);
    if (!Glob) {
      error(toString(Glob.takeError()));
      return;
    }
    ExactMatch = false;
    GlobPatternMatcher = *Glob;
  }
}

bool SingleStringMatcher::match(StringRef s) const {
  return ExactMatch ? (ExactPattern == s) : GlobPatternMatcher.match(s);
}

bool StringMatcher::match(StringRef s) const {
  for (const SingleStringMatcher &pat : patterns)
    if (pat.match(s))
      return true;
  return false;
}

std::string lld::convertToHex(StringRef Input) {
  static const char *const LUT = "0123456789abcdef";
  size_t Length = Input.size();

  std::string Output;
  Output.reserve(2 * Length);
  for (size_t i = 0; i < Length; ++i) {
    const unsigned char c = Input[i];
    Output.push_back(LUT[c >> 4]);
    Output.push_back(LUT[c & 15]);
  }
  return Output;
}

// Converts a hex string (e.g. "deadbeef") to a vector.
std::vector<uint8_t> lld::parseHex(StringRef s) {
  std::vector<uint8_t> hex;
  while (!s.empty()) {
    StringRef b = s.substr(0, 2);
    s = s.substr(2);
    uint8_t h;
    if (!to_integer(b, h, 16)) {
      error("not a hexadecimal value: " + b);
      return {};
    }
    hex.push_back(h);
  }
  return hex;
}

// Returns true if S is valid as a C language identifier.
bool lld::isValidCIdentifier(StringRef s) {
  return !s.empty() && !isDigit(s[0]) &&
         llvm::all_of(s, [](char c) { return isAlnum(c) || c == '_'; });
}

// Write the contents of the a buffer to a file
void lld::saveBuffer(StringRef buffer, const Twine &path) {
  std::error_code ec;
  raw_fd_ostream os(path.str(), ec, sys::fs::OpenFlags::OF_None);
  if (ec)
    error("cannot create " + path + ": " + ec.message());
  os << buffer;
}
