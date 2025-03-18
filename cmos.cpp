#include <iostream>
#include <fstream>
#include <vector>

using namespace std;

struct programSimilarity{
    string cFile1;
    string cFile2;
    float similarityScore;
};

struct cFile{
    pair<string, string> fileToToken;
    vector<size_t> hashedFingerprints;
};

int main (){
    const int FINGERPRINT_WIDTH = 4;
    const int WINDOW_SIZE = FINGERPRINT_WIDTH;
    ifstream file;
    vector<cFile> programs;
    string programName = "";
    string tokenizedProgram = "";

    file.open("./tokens.txt");

    if (!file)
    {
        std::cerr << "Unable to open file datafile.txt";
        exit(1);
    }

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
        vector<size_t> windows;
        hash<string> hash_fn;
        
        cout << "program " << i << endl;
        for (size_t j = 0; j < programs[i].fileToToken.second.size() - FINGERPRINT_WIDTH; j++){
            string kmer = programs[i].fileToToken.second.substr(j, FINGERPRINT_WIDTH);
            kmers.push_back(hash_fn(kmer));
        }
        size_t localsum = 0;
        for (size_t j = 0; j < kmers.size() - WINDOW_SIZE; j++){
            for (size_t k = 0; k < WINDOW_SIZE; k++){
                localsum += kmers[j + k];
            }
            windows.push_back(localsum);
            localsum = 0;
        }
        auto minHash = min(windows.begin(), windows.end());
        cout << "minHash: " << *minHash << endl;
        // programs[i].hashedFingerprints.push_back(minHash);
    }



    return 0;
}