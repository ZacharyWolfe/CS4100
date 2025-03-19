#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <algorithm>
#include <limits>

using namespace std;


struct cFile{
    pair<string, string> fileToToken;
    vector<size_t> hashedFingerprints;
};

int main (){
    const int FINGERPRINT_WIDTH = 4;
    const int WINDOW_SIZE = FINGERPRINT_WIDTH;
    ifstream file;
    vector<cFile> programs;
    map<string, float> filesAndSimilarities;
    string programName = "";
    string tokenizedProgram = "";
    string plagiarismLine = "";

    file.open("./tokens.txt");

    if (!file)
    {
        std::cerr << "Unable to open file datafile.txt";
        exit(1);
    }

    file >> plagiarismLine;
    file >> plagiarismLine;

    while (!file.eof()){
        file >> programName;
        file >> tokenizedProgram;
        cFile *program = new cFile();
        program->fileToToken = make_pair(programName, tokenizedProgram);
        programs.push_back(*program);
    }

    file.close();

    for (size_t i = 0; i < programs.size(); i++){
        vector<size_t> kmers;
        hash<string> hash_fn;
        
        if (programs[i].fileToToken.second.size() >= FINGERPRINT_WIDTH){
            for (size_t j = 0; j < programs[i].fileToToken.second.length() - FINGERPRINT_WIDTH; j++){
                string kmer = programs[i].fileToToken.second.substr(j, FINGERPRINT_WIDTH);
                kmers.push_back(hash_fn(kmer));
            }
        }
        for (size_t j = 0; j <= kmers.size() - WINDOW_SIZE; j++){
            size_t minHash = numeric_limits<size_t>::max();
            for (size_t k = 0; k < WINDOW_SIZE; k++){
                if (kmers[j + k] < minHash){
                    minHash = kmers[j + k];
                }
            }
            programs[i].hashedFingerprints.push_back(minHash);
        }
    }

    // calculate the similarity between each pair of programs
    for (size_t i = 0; i < programs.size(); ++i) {
        for (size_t j = i + 1; j < programs.size(); ++j) {
            size_t common = 0;
            for (size_t k = 0; k < programs[i].hashedFingerprints.size(); ++k) {
                for (size_t l = 0; l < programs[j].hashedFingerprints.size(); ++l) {
                    if (programs[i].hashedFingerprints[k] == programs[j].hashedFingerprints[l]) {
                        common++;
                    }
                }
            }

            float similarity = (float)common / (programs[i].hashedFingerprints.size() + programs[j].hashedFingerprints.size());
            filesAndSimilarities.insert(make_pair(programs[i].fileToToken.first + " " + programs[j].fileToToken.first, similarity));
        }
    }

    vector<pair<string, float>> filesAndSimilaritiesVector(filesAndSimilarities.begin(), filesAndSimilarities.end());
    sort(filesAndSimilaritiesVector.begin(), filesAndSimilaritiesVector.end(), [](const pair<string, float> &a, const pair<string, float> &b) {
        return a.second > b.second;
    });

    for (size_t i = 0; i < filesAndSimilaritiesVector.size(); ++i) {
        cout << filesAndSimilaritiesVector[i].first << " " << filesAndSimilaritiesVector[i].second << endl;
    }

    return 0;
}